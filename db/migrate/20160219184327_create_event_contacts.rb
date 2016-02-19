class CreateEventContacts < ActiveRecord::Migration
  def change
    create_table :event_contacts do |t|
      t.references :event, index: true, foreign_key: true
      t.references :contact, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
