class CreatePains < ActiveRecord::Migration
  def change
    create_table :pains do |t|
      t.string :pain_location
      t.integer :intensity
      t.datetime :pain_start_time
      t.datetime :pain_end_time
      t.text :notes
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
