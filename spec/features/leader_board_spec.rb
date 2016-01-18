require 'rails_helper'

describe 'leaderboard' do

  specify 'visit the leaderboard with no date passed and it defaults to the latest sprint' do

    visit '/'

    expect(page).to have_content "Sprint #{Sprint.last.start_date.to_date}"

  end



end
