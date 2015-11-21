class AddMddColToMyplaceonlineDueDisplays < ActiveRecord::Migration
  def change
    add_column :myplaceonline_due_displays, :drivers_license_expiration_threshold, :integer
    add_column :myplaceonline_due_displays, :birthday_threshold, :integer
    add_column :myplaceonline_due_displays, :promotion_threshold, :integer
    add_column :myplaceonline_due_displays, :gun_registration_expiration_threshold, :string
  end
end
