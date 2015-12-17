FactoryGirl.define do

  factory :data, class: Hashie::Mash do
    skip_create
    initialize_with{ new(attributes) }
  end

  factory :user_data, parent: :data do
    sequence(:id) { |n| n }
    type "User"
    login { Faker::Internet.user_name }
    avatar_url { "https://avatars.githubusercontent.com/u/#{id}?v=3" }
    name { Faker::Name.name }
  end

  factory :github_user do
    data { create :user_data }
  end

  factory :pull_request_payload_data, parent: :data do
    user { create :user_data }
    merged_by { create :user_data }
    merged true
  end


  factory :event_data, parent: :data do
    created_at "2015-12-14T23:38:54.000Z"
    sequence(:id) { |n| n }
  end

  factory :payload, parent: :data do
    action 'closed'
    pull_request { create :pull_request_payload_data }
  end

  factory :merged_pull_request_data, parent: :event_data do
    type 'PullRequestEvent'
    payload
    actor { create :user_data }
  end

  factory :merged_pull_request, class: Event do
    data { create :merged_pull_request_data }
    before(:create) do |object|
      create(:github_user, data: object.data.actor) unless GithubUser.where(github_id: object.data.actor.id).exists?
    end
  end


  factory :pull_request_comment_data, parent: :event_data do
    type "PullRequestReviewCommentEvent"
    payload
    actor { create :user_data }
  end


  factory :pull_request_comment, class: Event do
    data { create :pull_request_comment_data }
  end





end
