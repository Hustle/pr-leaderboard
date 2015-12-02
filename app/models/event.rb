class Event < ActiveRecord::Base

  serialize :data, HashSerializer

  class << self


    def add_events!
      client.organization_events('viewthespace', per_page: 1).each do |github_event|
        event = Event.find_by_github_id(github_event.id) || Event.new(github_id: github_event.id)
        event.data = github_event.to_h
        event.save!
      end
    end

    def client
      @client ||= Octokit::Client.new(:access_token => ENV['GITHUB_ACCESS_TOKEN'])
    end


  end



end
