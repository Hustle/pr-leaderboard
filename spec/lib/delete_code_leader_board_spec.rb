require 'rails_helper'

describe DeleteCodeLeaderBoard do

  let(:charley){ create(:github_user, data: create(:user_data, login: "CharlesMcMillan")) }
  let(:ian){ create(:github_user, data: create(:user_data, login: "ianforsyth")) }

  let(:date){ Date.parse('2015-12-17')   }


  before do
    #first sprint is
    Sprint.start_date = Time.zone.parse('2015-11-23')

    #currently Dec 17th so sprint started on the 7th
    Timecop.freeze date

    create(:merged_pull_request, data: build(:merged_pull_request_data, created_at: '2015-12-16',
                                             payload: create(:payload, pull_request: build(:pull_request_payload_data, user: ian.data, deletions: 10 )) ))

    create(:merged_pull_request, data: build(:merged_pull_request_data, created_at: '2015-12-16',
                                             payload: create(:payload, pull_request: build(:pull_request_payload_data, user: charley.data, deletions: 5 )) ))

    create(:merged_pull_request, data: build(:merged_pull_request_data, created_at: '2015-12-16',
                                             payload: create(:payload, pull_request: build(:pull_request_payload_data, user: charley.data, deletions: 2 )) ))
  end

  specify do
    expect(DeleteCodeLeaderBoard.new(date).results).to eq (
      [
        {
          "id"=>9,
          "deletions"=>10,
          "github_user"=> ian
        },
        {
          "id"=>12,
          "deletions"=>7,
          "github_user"=> charley
        }
      ]
    )
  end


end
