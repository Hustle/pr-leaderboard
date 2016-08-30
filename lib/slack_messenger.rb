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
      fallback: 'TODO',
      color: "#36a64f",
      fields: top_users
    }

# """{
#     "attachments": [
#         {
#             "fallback": "Required plain-text summary of the attachment.",
#             "color": "#36a64f",
#             "pretext": "Top PR leaderboard rankings",
#             "fields": [
#                 {
#                     "value": "1. charlesmcm - 24 points"
#                 },
#                 {
#                     "value": "2. charlesmcm - 45 points"
#                 },
#                 {
#                     "value": "3. charlesmcm - 45 points"
#                 }
#             ]
#         }
#     ]
# }
  end
end
