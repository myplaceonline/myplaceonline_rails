class CreateNotificationRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table :notification_registrations do |t|
      t.string :token
      t.references :user, foreign_key: true
      t.string :platform

      t.timestamps
    end
  end
end
