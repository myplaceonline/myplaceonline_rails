class CreateTimingEvents < ActiveRecord::Migration
  def change
    create_table :timing_events do |t|
      t.references :timing, index: true, foreign_key: true
      t.datetime :timing_event_start
      t.datetime :timing_event_end
      t.text :notes
      t.references :identity, index: true, foreign_key: true
      t.integer :visit_count

      t.timestamps null: false
    end
  end
end
