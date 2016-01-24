class AddColumnToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :notes, :text
  end
end
