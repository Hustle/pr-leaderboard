require 'rails_helper'

describe Sprint do

  describe '#last' do

    subject{ Sprint.last }

    specify do
      expect(subject).to  be_instance_of Sprint
    end

    specify 'by default it starts the previous monday' do
      expect(subject.start_date).to eq(Time.zone.now.beginning_of_week)
    end

    specify 'ends after two weeks' do
      expect(subject.end_date).to eq(subject.start_date + 2.weeks)
    end



  end

  describe '#all' do

  end



end
