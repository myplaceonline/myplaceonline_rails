class CreateEmergencyContacts < ActiveRecord::Migration
  def change
    create_table :emergency_contacts do |t|
      t.references :email, index: true, foreign_key: true
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
