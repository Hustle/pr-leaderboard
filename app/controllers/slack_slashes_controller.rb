class SlackSlashesController < ActionController::Base

  def create
    render json: {
      response_type: 'in_channel',
      text: format_data(LeaderBoard.results).join
    }
  end

  def format_data(ranking_data)
    list = ranking_data.each_with_index.map do |user, i|
      "#{user["github_user"]["name"]} #{user["points"]} points\n"
    end
  end

end
