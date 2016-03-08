require 'csv'

csv_out = CSV.generate do |csv|
  csv << [ "DayOfWeek", "Day", "Pull Request Comments"]

  Event.where('data @> ?', { type: 'PullRequestReviewCommentEvent' }.to_json).where("data->'payload'->'pull_request' -> 'user' -> 'id' != (data->'actor' -> 'id')").group('date(github_created_at)').order('date(github_created_at)').count.each do |day, count|
    csv << [day.strftime('%a'), day,count]
  end
end

File.open("./tmp/pr_comments_by_day.csv", "w+"){ |o| o.write csv_out }


