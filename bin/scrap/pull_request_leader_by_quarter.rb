merged_pr_stats = Event.where('data @> ?', { type: "PullRequestEvent", payload: { action: 'closed', pull_request: { merged: true } } }.to_json).
  where( "data-> 'payload' -> 'pull_request' -> 'user' -> 'login' != ( data->'payload'->'pull_request' -> 'merged_by' -> 'login')").
  where('github_created_at >= ? and github_created_at < ?', '2016-01-01', '2016-04-01').
  group("data -> 'payload' -> 'pull_request' -> 'merged_by' -> 'id'").order('count(*) desc').count


leader_data_hash = merged_pr_stats.each_with_object({}) do |(id, count), hash|
  hash[id] = { id: id, pull_request_merges: count, pull_request_comments: 0 }
end

pr_comment_stats = Event.where('data @> ?', { type: 'PullRequestReviewCommentEvent' }.to_json).
  where("data->'payload'->'pull_request' -> 'user' -> 'id' != (data->'actor' -> 'id')").
  where('github_created_at >= ? and github_created_at < ?', '2016-01-01', '2016-04-01').
  group("data -> 'actor' -> 'id'").order('count(*) desc').count

pr_comment_stats.each do |id, count|
  leader_data_hash[id] ||= { id: id, pull_request_merges: 0 }
  leader_data_hash[id].merge!( pull_request_comments: count )
end

leader_data_hash.values.each do |entry|
  entry[:points] = entry[:pull_request_comments] + (2 * entry[:pull_request_merges])
  entry[:github_user] = GithubUser.find_by_github_id!(entry[:id])
end
leader_data_hash.values.sort_by{|entry| entry[:points] }.reverse.collect{ |r| Hashie::Mash.new(r) }


