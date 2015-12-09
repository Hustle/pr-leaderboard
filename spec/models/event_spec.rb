require 'rails_helper'

describe Event do

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



    specify do
      event = Event.new
      event.data = github_data
      event.save!
      expect( ActiveSupport::HashWithIndifferentAccess.new(event.data)).to eq github_data
    end




  end


end
