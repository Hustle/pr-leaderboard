require 'thor'
require 'thor/rails'

class Slack < Thor
  include Thor::Rails

  desc 'current_standings', 'post current standings to Slack'
  def current_standings
    ::LeaderboardStandingsNotifier.new.current_standings
  end
end
