class CreateAlertsDisplays < ActiveRecord::Migration
  def change
    create_table :alerts_displays do |t|
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
