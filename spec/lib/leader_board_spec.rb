require 'rails_helper'

describe LeaderBoard do

  describe 'pulls the latest sprint by default' do

    let(:charley){ create(:github_user, data: create(:user_data, login: "CharlesMcMillan")) }
    let(:ian){ create(:github_user, data: create(:user_data, login: "ianforsyth")) }

    before do
      #first sprint is
      Sprint.start_date = Time.zone.parse('2015-11-23')

      #currently Dec 17th so sprint started on the 7th
      Timecop.freeze Time.zone.parse('2015-12-17')

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
      expect(LeaderBoard.new(Date.today).results).to eq(
        [
          {id: charley.github_id, pull_request_comments: 2, pull_request_merges: 1, points: 4  },
          {id: ian.github_id, :pull_request_merges=>1, :pull_request_comments=>0, :points=>2},
        ].map do |entry|
          ActiveSupport::HashWithIndifferentAccess.new entry.merge(github_user: GithubUser.find_by_github_id!(entry[:id]))
        end
      )
    end


    describe 'pulls the leaderboard for the first sprint' do
      before do
        create :pull_request_comment, data: create(:pull_request_comment_data, created_at: '2015-11-24', actor: charley.data)
        create :pull_request_comment, data: create(:pull_request_comment_data, created_at: '2015-11-26', actor: charley.data)
        create :pull_request_comment, data: create(:pull_request_comment_data, created_at: '2015-11-30', actor: ian.data)
      end

      specify do
        expect(LeaderBoard.new(Date.parse('2015-11-24')).results).to eq(
          [
            {id: charley.github_id, pull_request_comments: 3, pull_request_merges: 0, points: 3},
            {id: ian.github_id, pull_request_merges: 0, pull_request_comments: 2, points: 2},
          ].map{|entry| ActiveSupport::HashWithIndifferentAccess.new entry.merge(github_user: GithubUser.find_by_github_id(entry[:id])) }
        )
      end
    end



  end



  describe 'assembles the results into a leader board' do

    before do
      ["CharlesMcMillan", "ianforsyth", "the1337sauce", "pawelgut", "juliantejera"].each_with_index do |login, index|
        GithubUser.create! data: { login: login, id: index }
      end


      expect(Event).to receive(:merged_pull_request_counts).and_return({
        GithubUser.find_by_login!("CharlesMcMillan").github_id=>14,
        GithubUser.find_by_login!("the1337sauce").github_id=>11,
        GithubUser.find_by_login!("juliantejera").github_id=>7 })


      expect(Event).to receive(:pull_request_comment_counts).and_return({
        GithubUser.find_by_login!("ianforsyth").github_id=>26,
        GithubUser.find_by_login!("CharlesMcMillan").github_id=>22,
        GithubUser.find_by_login!("pawelgut").github_id=>21 })
    end

    specify 'returns the leader board' do
      expect(LeaderBoard.new(Date.today).results).to eq([
        {id: GithubUser.find_by_login!("CharlesMcMillan").github_id, pull_request_comments: 22, pull_request_merges: 14, points: 50  },
        {id: GithubUser.find_by_login!("ianforsyth").github_id, :pull_request_merges=>0, :pull_request_comments=>26, :points=>26},
        {id: GithubUser.find_by_login!("the1337sauce").github_id, pull_request_comments: 0, pull_request_merges: 11, points: 22  },
        {id: GithubUser.find_by_login!("pawelgut").github_id, pull_request_comments: 21, pull_request_merges: 0, points: 21 },
        {id: GithubUser.find_by_login!("juliantejera").github_id, pull_request_comments: 0, pull_request_merges: 7, points: 14 }
      ].map{|entry| ActiveSupport::HashWithIndifferentAccess.new entry.merge(github_user: GithubUser.find_by_github_id!(entry[:id])) })
    end

  end
end
