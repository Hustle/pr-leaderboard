require 'rails_helper'

describe LeaderBoard do

  describe 'pulls the latest sprint by default' do

    before do
      #first sprint is
      Sprint.start_date = Time.zone.parse('2015-11-23')

      #currently Dec 17th so sprint started on the 7th
      Timecop.freeze Time.zone.parse('2015-12-17')

      charley = create(:github_user, data: create(:user_data, login: "CharlesMcMillan"))
      ian = create(:github_user, data: create(:user_data, login: "ianforsyth"))

      #comment created before the 7th
      create :pull_request_comment, data: create(:pull_request_comment_data, created_at: '2015-12-06', actor: charley.data )

      #comment created on the 7th
      create :pull_request_comment, data: create(:pull_request_comment_data, created_at: '2015-12-07', actor: charley.data )

      #comment created on the 7th
      create :pull_request_comment, data: create(:pull_request_comment_data, created_at: '2015-12-07', actor: charley.data )

      create(:merged_pull_request, data: build(:merged_pull_request_data, created_at: '2015-12-16',
        payload: create(:payload, pull_request: build(:pull_request_payload_data, merged_by: charley.data )) ))

      #comment create before the 7th
      create :pull_request_comment, data: create(:pull_request_comment_data, created_at: '2015-12-06', actor: ian.data )

      #merge somethin in on 10th
      create(:merged_pull_request, data: build(:merged_pull_request_data, created_at: '2015-12-10',
        payload: create(:payload, pull_request: build(:pull_request_payload_data, merged_by: ian.data )) ))

    end

    specify 'pulls the leaderboard for the sprint starting the 6th' do
      expect(LeaderBoard.results).to eq(
        [
          {login: "CharlesMcMillan", pull_request_comments: 2, pull_request_merges: 1, points: 4  },
          {login: "ianforsyth", :pull_request_merges=>1, :pull_request_comments=>0, :points=>2},
        ].map{|entry| ActiveSupport::HashWithIndifferentAccess.new entry.merge(github_user: GithubUser.find_by_login!(entry[:login])) }
      )
    end

  end



  describe 'assembles the results into a leader board' do

    before do
      ["CharlesMcMillan", "ianforsyth", "the1337sauce", "pawelgut", "juliantejera"].each_with_index do |login, index|
        GithubUser.create! data: { login: login, id: index }
      end


      expect(Event).to receive(:merged_pull_request_counts).and_return({
        "CharlesMcMillan"=>14,
        "the1337sauce"=>11,
        "juliantejera"=>7 })


      expect(Event).to receive(:pull_request_comment_counts).and_return({
        "ianforsyth"=>26,
        "CharlesMcMillan"=>22,
        "pawelgut"=>21 })
    end

    specify 'returns the leader board' do
      expect(LeaderBoard.results).to eq([
        {login: "CharlesMcMillan", pull_request_comments: 22, pull_request_merges: 14, points: 50  },
        {login: "ianforsyth", :pull_request_merges=>0, :pull_request_comments=>26, :points=>26},
        {login: "the1337sauce", pull_request_comments: 0, pull_request_merges: 11, points: 22  },
        {login: "pawelgut", pull_request_comments: 21, pull_request_merges: 0, points: 21 },
        {login: "juliantejera", pull_request_comments: 0, pull_request_merges: 7, points: 14 }
      ].map{|entry| ActiveSupport::HashWithIndifferentAccess.new entry.merge(github_user: GithubUser.find_by_login!(entry[:login])) })
    end

  end
end
