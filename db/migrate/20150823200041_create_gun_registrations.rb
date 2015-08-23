class CreateGunRegistrations < ActiveRecord::Migration
  def change
    create_table :gun_registrations do |t|
      t.references :location, index: true
      t.date :registered
      t.date :expires
      t.references :gun, index: true
      t.references :owner, index: true

      t.timestamps
    end
  end
end
