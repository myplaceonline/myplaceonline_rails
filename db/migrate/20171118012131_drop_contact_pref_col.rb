class DropContactPrefCol < ActiveRecord::Migration[5.1]
  def change
    remove_column :contacts, :contact_preference
  end
end
