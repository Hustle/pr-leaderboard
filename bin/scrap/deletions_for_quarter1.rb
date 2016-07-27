Event.where('data @> ?', { type: "PullRequestEvent", payload: { action: 'closed', pull_request: { merged: true } } }.to_json).where( "data-> 'payload' -> 'pull_request' -> 'user' -> 'login' != ( data->'payload'->'pull_request' -> 'merged_by' -> 'login')").where('github_created_at >= ? and github_created_at < ?', '2016-01-01', '2016-04-01').select("data -> 'payload' -> 'pull_request' -> 'user' -> 'id' as id, data -> 'payload' -> 'pull_request' -> 'deletions' as deletes").
  each_with_object(Hash.new(0)){|event, hash| hash[event.id] += event.deletes }.
  map{|id, deletions| Hashie::Mash.new(id: id, deletions: deletions) }.sort_by(&:deletions).reverse

