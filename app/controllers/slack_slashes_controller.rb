class SlackSlashesController < ActionController::Base

  def create
    text = format_data(LeaderBoard.results).join
    Rails.logger.debug text
    render json: {
      response_type: 'in_channel',
      text: text
    }
  end

  def format_data(ranking_data)
    list = ranking_data.map do |user|
      "#{user["github_user"]["name"]} #{user["points"]} points\n"
    end
  end

end
