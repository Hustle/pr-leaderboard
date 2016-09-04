#require 'ostruct'

class SlackMessenger

  def initialize
    @slack_user = ENV['SLACK_USER']
    @slack_channel = ENV['SLACK_CHANNEL']
    @slack_webhook = ENV['SLACK_WEBHOOK']
  end

  def post_top_leaderboards(top_user_data)
    notifier = Slack::Notifier.new(@slack_webhook, channel: @slack_channel, username: @slack_user)
    notifier.ping('Top 5 PR Leaderboard standings', attachments: [format_top_leaderboards_message(top_user_data)])
  end

  private

  def format_top_leaderboards_message(top_user_data)
    top_users = top_user_data[:pr_leaders].shift(5).each_with_index.map do |user, i|
      { value: "#{i+1}. #{user[:github_user].login} - #{user[:points]} points" }
    end

    # message attachment json
    {
      fallback: 'top 5 leaderboard standings',
      color: "#36a64f",
      fields: top_users
    }
  end
end
