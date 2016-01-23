class LeaderBoardController < ApplicationController

  helper_method :sprint

  def show
    if request.format.html?
      @results = LeaderBoard.new(date).results
    else
      render json: LeaderBoard.new(date).results
    end
  end

end
