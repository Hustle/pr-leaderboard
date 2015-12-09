Event.find_each do |event|
  #fix payload
  puts "updating #{event.id} - #{event.github_created_at}"
  event.data.payload = event.data.payload.each_with_object({}){|(key,value), hash| hash[key] = value } if event.data.payload.is_a?(Array)
  event.data.actor = event.data.actor.each_with_object({}){|(key,value), hash| hash[key] = value } if event.data.actor.is_a?(Array)
  event.data.payload.comment = event.data.payload.comment.each_with_object({}){|(key,value), hash| hash[key] = value } if event.data.payload.try(:comment).is_a?(Array)
  event.data.repo = event.data.repo.each_with_object({}){|(key,value), hash| hash[key] = value } if event.data.repo.is_a?(Array)
  if event.payload.try(:pull_request)
    event.data.payload.pull_request = event.data.payload.pull_request.each_with_object({}){|(key,value), hash| hash[key] = value } if event.payload.pull_request.is_a?(Array)
    event.data.payload.pull_request.merged_by =event.data.payload.pull_request.merged_by.each_with_object({}){|(key,value), hash| hash[key] = value } if event.payload.pull_request.merged_by.is_a?(Array)
    event.data.payload.pull_request.user = event.data.payload.pull_request.user.each_with_object({}){|(key,value), hash| hash[key] = value } if event.payload.pull_request.user.is_a?(Array)
  end

  if event.type == 'PushEvent'
    event.data.payload.commits = event.payload.commits.map do |commit|
      commit = commit.each_with_object({}){|(key,value), hash| hash[key] = value } if commit.is_a?(Array)
      commit[:author] = commit[:author].each_with_object({}){|(key,value), hash| hash[key] = value } if commit[:author].is_a?(Array)
      commit
    end
  end



  event.save!
end
