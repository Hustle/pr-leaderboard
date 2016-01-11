require 'rails_helper'

describe Sprint do

  before do
    Sprint.start_date = nil
  end

  describe 'Sprint#start_date' do

    context 'default start date is the previous monday' do

      before do
        Sprint.start_date = nil
        Timecop.freeze Time.parse('2015-10-08')
      end

      specify do
        expect(Sprint.start_date).to eq Time.zone.parse('2015-10-05')
      end

    end


  end

  describe '#last' do

    subject{ Sprint.last }


    specify do
      expect(subject).to  be_instance_of Sprint
    end

    context 'no sprint start date set' do

      specify 'by default it starts the previous monday' do
        expect(subject.start_date).to eq(Time.zone.now.beginning_of_week)
      end

      specify 'ends after two weeks' do
        expect(subject.end_date).to eq(subject.start_date + 2.weeks)
      end

    end


    context 'sprint start date is set' do

      before do
        Sprint.start_date = Time.zone.parse('2015-10-05')
        Timecop.freeze Time.zone.parse('2015-12-08')
      end

      specify 'sprint start' do
        expect(subject.start_date).to eq Time.zone.parse('2015-11-30')
      end

      specify 'sprint length is 2 weeks later' do
        expect(subject.end_date).to eq(subject.start_date + 2.weeks)
      end


      specify '#all returns the sprints since sprint start in reverse order' do

        expect(Sprint.all.map{|sprint| [sprint.start_date, sprint.end_date]}).to eq(
          [
            ['2015-11-30', '2015-12-14'],
            ['2015-11-16', '2015-11-30'],
            ['2015-11-02', '2015-11-16'],
            ['2015-10-19', '2015-11-02'],
            ['2015-10-05', '2015-10-19']
          ].map do |(start_date, end_date)|
            [ Time.zone.parse(start_date), Time.zone.parse(end_date) ]
          end
        )

      end

      describe 'sprint for a given date' do

        specify 'sprint exists with exact start date' do

          expect(Sprint.for_date(Date.parse '2015-10-05').start_date).to eq(Date.parse '2015-10-05' )

        end

      end

    end
  end


  after do
    Timecop.return
  end

end
