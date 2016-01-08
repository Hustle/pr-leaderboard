require 'rails_helper'

describe SlackFormatter do

  it 'formats output correctly for Slack' do
    data = [{
      "pull_request_merges" => 12,
      "pull_request_comments" => 31,
      "points" => 55,
      "github_user"=> {
        "data" => {
          "login" => "ianforsyth",
          "name" => "Ian Forsyth"
        }
      }
    }]

    expected = "1. ianforsyth 55 points"

    expect(SlackFormatter.format(data)).to eq expected
  end

end
