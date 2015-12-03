class Event < ActiveRecord::Base

  serialize :data, HashSerializer

  before_save :set_github_id

  class << self


    def add_events!
      client.organization_events('viewthespace', per_page: 1).each do |github_event|
        event = Event.find_by_github_id(github_event.id) || Event.new
        event.data = github_event.to_h
        event.save!
      end
    end

    def client
      $github_client
    end


  end

  private

  def set_github_id
    self.github_id = data[:id]
  end


end
