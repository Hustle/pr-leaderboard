require 'rails_helper'

describe LeaderBoardController do

  before do
    Timecop.freeze
  end


  describe 'Returns leader board results for today if not date specified' do

    before do
      Timecop.freeze
      expect(LeaderBoard).to receive(:new).with(Date.today).and_return(double(:leader_board, results: []))
    end

    specify do
      get :show
    end

  end

  describe 'Returns leader board results for today if not date specified' do

    before do
      expect(LeaderBoard).to receive(:new).with(Date.today).and_return(double(:leader_board, results: []))
    end

    specify do
      get :show
    end

  end

  describe 'Returns leader board for a date passed in' do

    let(:date){ 3.days.ago.to_date }

    before do
      expect(LeaderBoard).to receive(:new).with(date).and_return(double(:leader_board, results: []))
    end

    specify do
      get :show, date: date.to_s
    end


  end





end
