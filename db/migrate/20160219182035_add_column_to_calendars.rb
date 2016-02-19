class AddColumnToCalendars < ActiveRecord::Migration
  def change
    add_column :calendars, :happy_things_threshold, :integer
  end
end
