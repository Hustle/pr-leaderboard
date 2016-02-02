class LeaderBoardController < ApplicationController

  helper_method :sprint

  def show
    if request.format.html?
      @results = results
    else
      render json: results
    end
  end

  private

  def results
    LeaderBoard.new(date).results
  end


end
