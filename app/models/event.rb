class Event < ActiveRecord::Base

  serialize :data, HashSerializer

  before_save :set_github_id
  before_save :set_github_created_at
  after_save :create_github_user

  store_accessor :data, :org, :repo, :type, :actor, :public, :payload

  def self.for_sprint(sprint)
    where('github_created_at >= ? and github_created_at < ?', sprint.start_date, sprint.end_date)
  end

  class << self



    def create_unless_exists! data
      Event.create!(data: data) unless data[:id].blank? ||  Event.where(github_id: data[:id]).exists?
    end

    def deletions_by_login(date = Date.today)
       merged_pull_request_events(date).
         select("data -> 'payload' -> 'pull_request' -> 'user' -> 'id' as id, data -> 'payload' -> 'pull_request' -> 'deletions' as deletes").
         each_with_object(Hash.new(0)){|event, hash| hash[event.id] += event.deletes }.
         map{|id, deletions| Hashie::Mash.new(id: id, deletions: deletions) }.sort_by(&:deletions).reverse
    end

    def merged_pull_request_counts(date = Date.today)
      merged_pull_request_events(date).group("data -> 'payload' -> 'pull_request' -> 'merged_by' -> 'login'").order('count(*) desc').count
    end

    def pull_request_comment_counts(date = Date.today)
      pull_request_comment_events(date).group("data -> 'actor' -> 'login'").order('count(*) desc').count
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

    def pull_request_comment_events(date)
      where('data @> ?', { type: 'PullRequestReviewCommentEvent' }.to_json).
        where("data->'payload'->'pull_request' -> 'user' -> 'id' != (data->'actor' -> 'id')").
        for_sprint(Sprint.for_date(date))
    end


    def merged_pull_request_events(date)
      where('data @> ?', { type: "PullRequestEvent", payload: { action: 'closed', pull_request: { merged: true } } }.to_json).
        where( "data-> 'payload' -> 'pull_request' -> 'user' -> 'login' != ( data->'payload'->'pull_request' -> 'merged_by' -> 'login')").
        for_sprint(Sprint.for_date(date))
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
