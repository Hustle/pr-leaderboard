FactoryGirl.define do

  factory :data, class: Hashie::Mash do
    skip_create
    initialize_with{ new(attributes) }
  end

  factory :user_data, parent: :data do
    data {
      {
        "id"=>96786,
        "url"=>"https://api.github.com/users/kbaum",
        "type"=>"User",
        "login"=>"kbaum",
        "html_url"=>"https://github.com/kbaum",
        "gists_url"=>"https://api.github.com/users/kbaum/gists{/gist_id}",
        "repos_url"=>"https://api.github.com/users/kbaum/repos",
        "avatar_url"=>"https://avatars.githubusercontent.com/u/96786?v=3",
        "events_url"=>"https://api.github.com/users/kbaum/events{/privacy}",
        "site_admin"=>false,
        "gravatar_id"=>"",
        "starred_url"=>"https://api.github.com/users/kbaum/starred{/owner}{/repo}",
        "followers_url"=>"https://api.github.com/users/kbaum/followers",
        "following_url"=>"https://api.github.com/users/kbaum/following{/other_user}",
        "organizations_url"=>"https://api.github.com/users/kbaum/orgs",
        "subscriptions_url"=>"https://api.github.com/users/kbaum/subscriptions",
        "received_events_url"=>"https://api.github.com/users/kbaum/received_events"
      }
    }
    initialize_with { Hashie::Mash.new(data) }
  end



  factory :event_data, parent: :data do
    created_at "2015-12-14T23:38:54.000Z"
    id { SecureRandom.uuid }
  end

  factory :payload, parent: :data do
    action 'closed'
    pull_request
  end

  factory :merged_pull_request_data, parent: :event_data do
    type 'PullRequestEvent'
    payload
  end


  factory :pull_request_comment_data, parent: :event_data do
    type "PullRequestReviewCommentEvent"
  end


  factory :pull_request, class: Event do
    data { create :pull_request_data}
  end

  factory :pull_request_comment, class: Event do
    data { create :pull_request_comment_data }
  end







end
