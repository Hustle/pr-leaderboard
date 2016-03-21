class LeaderBoard < Struct.new(:date)

  def results
    leader_data_hash = Event.merged_pull_request_counts(date).each_with_object({}) do | (id, count), hash|
      hash[id] = { id: id, pull_request_merges: count, pull_request_comments: 0 }
    end
    Event.pull_request_comment_counts(date).each do |id, count|
      leader_data_hash[id] ||= { id: id, pull_request_merges: 0 }
      leader_data_hash[id].merge!( pull_request_comments: count )
    end
    leader_data_hash.values.each do |entry|
      entry[:points] = entry[:pull_request_comments] + (2 * entry[:pull_request_merges])
      entry[:github_user] = GithubUser.find_by_github_id!(entry[:id])
    end
    leader_data_hash.values.sort_by{|entry| entry[:points] }.reverse.collect{ |r| Hashie::Mash.new(r) }
  end

end
