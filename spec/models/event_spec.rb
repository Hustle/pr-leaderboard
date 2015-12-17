require 'rails_helper'

describe Event, vcr: { record: :none } do

  def merged_pull_request(merged_by:, created_at:)
    create(:merged_pull_request, data: build(:merged_pull_request_data, created_at: created_at, payload: create(:payload, pull_request: build(:pull_request_payload_data, merged_by: create(:user_data, login: merged_by) )) ))
  end



  describe '#pull_request_comment_counts' do
    before do
      Timecop.freeze Time.zone.parse('2015-12-19')
      #let's not create a github user to avoid call to github api
      allow_any_instance_of(Event).to receive(:create_github_user)
      create :pull_request_comment, data: create(:pull_request_comment_data, created_at: '2015-12-18', actor: create(:user_data, login: 'noah') )
      create :pull_request_comment, data: create(:pull_request_comment_data, created_at: '2015-12-15', actor: create(:user_data, login: 'gracie') )
      create :pull_request_comment, data: create(:pull_request_comment_data, created_at: '2015-12-18', actor: create(:user_data, login: 'noah') )
      create :pull_request_comment, data: create(:pull_request_comment_data, created_at: '2015-12-16', actor: create(:user_data, login: 'josie') )
      create :pull_request_comment, data: create(:pull_request_comment_data, created_at: '2015-12-13', actor: create(:user_data, login: 'josie') )
    end

    specify do
      expect(Event.pull_request_comment_counts).to eq( HashWithIndifferentAccess.new(
        gracie: 1,
        josie: 1,
        noah: 2
      ))
    end
  end

  describe '#merged_pull_request_counts' do

    before do
      allow_any_instance_of(Event).to receive(:create_github_user)
      Timecop.freeze Time.zone.parse('2015-12-16')
      merged_pull_request(merged_by: 'noah', created_at: '2015-12-15')
      merged_pull_request(merged_by: 'noah', created_at: '2015-12-16')
      merged_pull_request(merged_by: 'josie', created_at: '2015-12-16')
      #doesn't count because before sprint started
      merged_pull_request(merged_by: 'josie', created_at: '2015-12-13')

      #wrong type of event
      create :pull_request_comment, data: create(:pull_request_comment_data, created_at: '2015-12-15')
    end

    specify do
      expect(Event.merged_pull_request_counts).to eq(HashWithIndifferentAccess.new(
        josie: 1,
        noah: 2
      ))
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
