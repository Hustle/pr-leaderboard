require 'rails_helper'

describe Sprint do

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

      after do
        Timecop.return
      end



    end



  end

  describe '#all' do

  end



end
