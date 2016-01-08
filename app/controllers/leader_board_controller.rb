class LeaderBoardController < ApplicationController
  def show
    if request.format.html?
      @results = LeaderBoard.results
    else
      render json: LeaderBoard.results.to_json
    end
  end
end
