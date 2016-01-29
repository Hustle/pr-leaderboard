require 'rails_helper'

describe 'delete code leader board' do
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

    visit delete_code_leader_board_path
  end

  specify do
    expect(page).to have_content 'Sprint 2015-12-07'

    #has the right content
    within ".user_#{ian.data.login}" do
      expect(page).to have_selector("img[src='#{ian.data.avatar_url}']")
      expect(page).to have_selector('td', text: ian.data.name)
      expect(page).to have_selector('td', text: 10)
    end

    #has the right order
    expect(page.all('.deletions').collect(&:text)).to eq(['10', '7'])

  end



end
