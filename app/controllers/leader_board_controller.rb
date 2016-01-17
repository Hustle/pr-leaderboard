class LeaderBoardController < ApplicationController
  def show
    if request.format.html?
      @results = LeaderBoard.new(date).results
    else
      render json: LeaderBoard.new(date).results
    end
  end


  private

  def date
    Date.parse(params[:date].presence || Date.today.to_s)
  end

end
