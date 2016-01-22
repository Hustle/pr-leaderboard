class DeleteCodeLeaderBoardController < ApplicationController

  def show
    @results = DeleteCodeLeaderBoard.new(Date.today).results
  end

end
