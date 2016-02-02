require 'rails_helper'

describe SlackSlashesController do

  describe 'Returns slack response for leader board results for today if not date specified' do

    before do
      expect(LeaderBoard).to receive(:new).with(Date.today).and_return(double(:leader_board, results: []))
    end

    specify do
      post :create
      expect(JSON.parse(response.body)).to eq ({ "response_type" => 'in_channel', "text" => '' })
    end
  end
end
