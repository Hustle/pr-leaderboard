class Event < ActiveRecord::Base

  serialize :data, HashSerializer

  before_save :set_github_id
  before_save :set_github_created_at

  store_accessor :data, :org, :repo, :type, :actor, :public, :payload

  class << self

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
        where("data->'payload'->'pull_request' -> 'user' -> 'id' != (data->'actor' -> 'id')")
    end



    def merged_pull_request_events
      where('data @> ?', { type: "PullRequestEvent", payload: { action: 'closed', pull_request: { merged: true } } }.to_json).
        where( "data-> 'payload' -> 'pull_request' -> 'user' -> 'login' != ( data->'payload'->'pull_request' -> 'merged_by' -> 'login')")
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

end
