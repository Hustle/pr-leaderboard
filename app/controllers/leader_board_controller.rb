class LeaderBoardController < ApplicationController
  def show
    @results = LeaderBoard.results
  end
end
