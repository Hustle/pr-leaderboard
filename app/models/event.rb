class Event < ActiveRecord::Base

  serialize :data, HashSerializer

  before_save :set_github_id
  before_save :set_github_created_at
  after_save :create_github_user

  store_accessor :data, :org, :repo, :type, :actor, :public, :payload

  def self.this_week
    where('github_created_at >= ?', Time.zone.now.beginning_of_week)
  end

  class << self


    def create_unless_exists! data
      Event.create!(data: data) unless data[:id].blank? ||  Event.where(github_id: data[:id]).exists?
    end

    def merged_pull_request_counts
      merged_pull_request_events.group("data -> 'payload' -> 'pull_request' -> 'merged_by' -> 'login'").order('count(*) desc').count
    end

    def pull_request_comment_counts
      pull_request_comment_events.group("data -> 'actor' -> 'login'").order('count(*) desc').count
    end

    def add_events!
      client.organization_events('viewthespace', per_page: 100).each do |github_event|
        Rails.logger.info("Add/updating event #{github_event.id}")
        event = Event.find_by_github_id(github_event.id) || Event.new
        event.data = github_event.to_attrs
        event.save!
      end
    end

    private

    def pull_request_comment_events
      where('data @> ?', { type: 'PullRequestReviewCommentEvent' }.to_json).
        where("data->'payload'->'pull_request' -> 'user' -> 'id' != (data->'actor' -> 'id')").
        this_week
    end


    def merged_pull_request_events
      where('data @> ?', { type: "PullRequestEvent", payload: { action: 'closed', pull_request: { merged: true } } }.to_json).
        where( "data-> 'payload' -> 'pull_request' -> 'user' -> 'login' != ( data->'payload'->'pull_request' -> 'merged_by' -> 'login')").
        this_week
    end

    def client
      $github_client
    end

  end

  private

  def set_github_id
    self.github_id = data[:id]
  end

  def set_github_created_at
    self.github_created_at = data[:created_at]
  end

  def create_github_user
    GithubUser.create_unless_exists!(actor.id) if actor
  end

end
