class CreateNotificationPreferences < ActiveRecord::Migration[5.1]
  def change
    create_table :notification_preferences do |t|
      t.integer :notification_type
      t.string :notification_category
      t.boolean :notifications_enabled
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.boolean :is_public
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
