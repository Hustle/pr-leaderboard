require 'rails_helper'

describe SlackMessenger do

  describe '#post_top_leaderboards' do

    let(:top_user_data) {
      {
        pr_leaders:
          [
            {
              points: 100,
              github_user: OpenStruct.new(login: 'joe')
            },
            {
              points: 80,
              github_user: OpenStruct.new(login: 'jane')
            },
            {
              points: 70,
              github_user: OpenStruct.new(login: 'john')
            }
          ]
      }
    }

    it 'posts top user data to slack' do
      slack_mock = double
      expect(::Slack::Notifier).to receive(:new).and_return(slack_mock)
      expect(slack_mock).to receive(:ping)
        .with(
          'Top 5 PR Leaderboard standings',
          { attachments:
              [{
                fallback: 'top 5 leaderboard standings',
                color: "#36a64f",
                fields:
                  [
                    { value: "1. joe - 100 points" },
                    { value: "2. jane - 80 points" },
                    { value: "3. john - 70 points" }
                  ]
              }]
          }
        )

      SlackMessenger.new.post_top_leaderboards(top_user_data)
    end
  end
end
