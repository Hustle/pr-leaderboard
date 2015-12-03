class AddTypeIndexToEventsData < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.execute(
      "CREATE INDEX events_type ON events ((data->>'type'));"
    )
  end
end
