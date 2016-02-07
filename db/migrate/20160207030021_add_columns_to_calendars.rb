class AddColumnsToCalendars < ActiveRecord::Migration
  def change
    add_column :calendars, :general_threshold, :integer
  end
end
