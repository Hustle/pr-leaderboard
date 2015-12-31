class SlackSlashesController

  def create
    render format_data(LeaderBoard.results)
  end

  def format_data(ranking_data)
    ranking_data.map do |user|
      "1. #{user["github_user"]["name"]} #{user["points"]}\n"
    end
  end

end
