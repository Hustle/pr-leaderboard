class SlackFormatter
  class << self
    def format(ranking_data)
      list = ranking_data.each_with_index.map do |user, i|
        "#{i+1}. #{user["github_user"]["data"]["name"]} #{user["points"]} points"
      end
      list.join("\n")
    end
  end
end
