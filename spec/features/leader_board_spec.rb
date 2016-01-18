require 'rails_helper'

describe 'leaderboard' do

  specify 'visit the leaderboard with no date passed and it defaults to the latest sprint' do

    visit '/'

    expect(page).to have_content "Sprint #{Sprint.last.start_date.to_date}"

  end


  describe 'pass in dates for previous sprints' do

    before do
      Sprint.start_date = Date.parse('2016-01-04')
      Timecop.freeze '2016-01-18'
    end

    specify 'visit for current sprint' do

      visit '/'

      expect(page).to have_content "Sprint 2016-01-18"

    end

    specify 'pass a date in to see previous sprint' do
      visit root_path(date: '2016-01-06')

      expect(page).to have_content "Sprint 2016-01-04"
    end


  end


end
