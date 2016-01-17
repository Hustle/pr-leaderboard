class LeaderBoard < Struct.new(:date)


  def results
    leader_data_hash = Event.merged_pull_request_counts.each_with_object({}) do | (login, count), hash|
      hash[login] = { login: login, pull_request_merges: count, pull_request_comments: 0 }
    end
    Event.pull_request_comment_counts.each do |login, count|
      leader_data_hash[login] ||= { login: login, pull_request_merges: 0 }
      leader_data_hash[login].merge!( pull_request_comments: count )
    end
    leader_data_hash.values.each do |entry|
      entry[:points] = entry[:pull_request_comments] + (2 * entry[:pull_request_merges])
      entry[:github_user] = GithubUser.find_by_login!(entry[:login])
    end
    leader_data_hash.values.sort_by{|entry| entry[:points] }.reverse.collect{ |r| Hashie::Mash.new(r) }
  end


end
