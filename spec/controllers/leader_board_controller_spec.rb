require 'spec_helper'

describe LeaderBoardController do


  describe 'Returns leader board results for today if not date specified' do

    before do
      Timecop.freeze
      expect(LeaderBoard).to receive(:new).with(Date.today).and_return(double(:leader_board, results: []))
    end

    specify do
      get :show
    end


  end

end
