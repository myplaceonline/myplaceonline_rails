class ChangeMddCol < ActiveRecord::Migration
  def change
    remove_column :myplaceonline_due_displays, :gun_registration_expiration_threshold
    add_column :myplaceonline_due_displays, :gun_registration_expiration_threshold, :integer
  end
end
