class LeaderboardStandingsNotifier

  def current_standings
    standings = LeaderBoard.new(Sprint.last.start_date.to_s).results
    SlackMessenger.new.post_top_leaderboards(pr_leaders: standings)
  end

end
