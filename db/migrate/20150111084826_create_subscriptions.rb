class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
