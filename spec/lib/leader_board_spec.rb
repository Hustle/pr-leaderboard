require 'rails_helper'

describe LeaderBoard do

  before do
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
    ])
  end
end
