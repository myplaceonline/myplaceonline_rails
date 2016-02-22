class AddColumnsToAlertsDisplays < ActiveRecord::Migration
  def change
    add_column :alerts_displays, :suppress_hotel, :boolean
  end
end
