class DeleteCodeLeaderBoard < Struct.new(:date)

  def results
    Event.deletions_by_login(date).each do |entry|
      entry[:github_user] = GithubUser.find_by_login!(entry[:login])
    end
  end

end
