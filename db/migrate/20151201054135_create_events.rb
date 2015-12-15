class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :event_name
      t.text :notes
      t.datetime :event_time
      t.integer :visit_count
      t.references :owner, index: true
      t.references :reminder, index: true

      t.timestamps null: true
    end
  end
end
