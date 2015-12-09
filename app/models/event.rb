class Event < ActiveRecord::Base

  serialize :data, HashSerializer

  before_save :set_github_id
  before_save :set_github_created_at

  store_accessor :data, :org, :repo, :type, :actor, :public, :payload

  class << self

    def merged_pull_request_counts
      Hash[merged_pull_request_events.group_by{|event| event.payload.pull_request.merged_by.login}.
        each_with_object({}){|(key, value), hash| hash[key] = value.length}.
        sort_by{|(key,value)| value }.reverse]
    end

    def merged_pull_request_events
      #closed merge
      Event.where('data @> ?', { type: "PullRequestEvent", payload: { action: 'closed', pull_request: { merged: true } } }.to_json).
        select{|e| e.payload.pull_request.user.login != e.payload.pull_request.merged_by.login }
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
