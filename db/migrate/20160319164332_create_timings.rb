class CreateTimings < ActiveRecord::Migration
  def change
    create_table :timings do |t|
      t.string :timing_name
      t.text :notes
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
