class CreateEventRsvps < ActiveRecord::Migration
  def change
    create_table :event_rsvps do |t|
      t.references :event, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.integer :rsvp_type
      t.string :email

      t.timestamps null: false
    end
  end
end
