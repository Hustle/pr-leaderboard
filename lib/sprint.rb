class Sprint

  def initialize(start_date:, end_date: nil)
    @start_date = start_date
    @end_date = end_date
  end

  class << self

    def start_date=(sd)
      @start_date = sd
    end

    def start_date
      @start_date ||= Time.zone.now.beginning_of_week
    end

  end

  def self.last
    all.first
  end

  def self.all
    results = []
    current_start = start_date
    loop do
      results << Sprint.new(start_date: current_start)
      current_start += 2.weeks
      break if current_start > Time.zone.now
    end
    results.reverse
  end

  def start_date
    @start_date ||= Time.zone.now.beginning_of_week
  end

  def end_date
    @end_date ||= (start_date + 2.weeks)
  end

end
