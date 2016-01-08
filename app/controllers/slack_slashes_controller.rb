class SlackSlashesController < ActionController::Base

  def create
    text = SlackFormatter.format(LeaderBoard.results)
    Rails.logger.debug text
    render json: {
      response_type: 'in_channel',
      text: text
    }
  end


end
