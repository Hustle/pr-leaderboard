class Event < ActiveRecord::Base

  serialize :data, HashSerializer

  class << self


    def add_events!
      client.organization_events('viewthespace', per_page: 5).each do |event|
        self.create!(data: event.to_h)
      end
    end

    def client
      @client ||= Octokit::Client.new(:access_token => ENV['GITHUB_ACCESS_TOKEN'])
    end


  end



end
