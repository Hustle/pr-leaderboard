class LeaderBoardController < ApplicationController
  def show
    if request.format.html?
      @results = LeaderBoard.new(Date.today).results
    else
      render json: LeaderBoard.new(Date.today).results
    end
  end
end
