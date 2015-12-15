class Sprint

  def self.last
    Sprint.new
  end

  def start_date
    Time.zone.now.beginning_of_week
  end

  def end_date
    start_date + 2.weeks
  end

end
