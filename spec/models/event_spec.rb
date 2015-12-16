require 'rails_helper'

describe Event, vcr: { record: :none } do

  describe '#merged_pull_request_counts' do

    before do
      Timecop.freeze Time.zone.parse('2015-12-16')
      create(:merged_pull_request, data: build(:merged_pull_request_data, created_at: Time.zone.parse('2015-12-15') ))
    end

    specify do
      expect(Event.merged_pull_request_counts).to eq({})
    end


  end



  describe 'data is stored properly' do

    let(:github_data) do
       ActiveSupport::HashWithIndifferentAccess.new({
       :id=>"3421434763",
       :type=>"CreateEvent",
       :actor=>{
         :id=>6278442,
         :login=>"the1337sauce",
         :gravatar_id=>"",
         :url=>"https://api.github.com/users/the1337sauce",
         :avatar_url=>"https://avatars.githubusercontent.com/u/6278442?"
       },
       :repo=> {
         :id=>13781958,
         :name=>"viewthespace/viewthespace-ios",
         :url=>"https://api.github.com/repos/viewthespace/viewthespace-ios"},
         :payload=>{
           :ref=>"chore/log_deal_ui_tests",
           :ref_type=>"branch",
           :master_branch=>"master",
           :description=>"",
           :pusher_type=>"user"
         },
         :public=>false,
         :created_at=>"2015-12-08 18:45:01 UTC",
         :org=>{
           :id=>974228,
           :login=>"viewthespace",
           :gravatar_id=>"",
           :url=>"https://api.github.com/orgs/viewthespace",
           :avatar_url=>"https://avatars.githubusercontent.com/u/974228?"
         }
      })
    end


    let!(:event){ Event.create_unless_exists! github_data }

    specify 'skips if there is no id for some reason' do
      expect{ Event.create_unless_exists!({}) }.to_not raise_error
    end

    specify 'calling create unless exists does not do anything if the event already exists' do
      expect{ Event.create_unless_exists! github_data }.to_not raise_error
    end

    specify 'data is stored in database' do
      expect( ActiveSupport::HashWithIndifferentAccess.new(event.data)).to eq github_data
    end

    specify 'github user is added to database' do
      expect(GithubUser.where(github_id: 6278442)).to exist
    end

  end


end
