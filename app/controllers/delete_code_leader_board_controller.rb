class DeleteCodeLeaderBoardController < ApplicationController

  def show
    @results = DeleteCodeLeaderBoard.new(date).results
  end

end
