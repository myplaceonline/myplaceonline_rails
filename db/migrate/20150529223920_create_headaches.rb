class CreateHeadaches < ActiveRecord::Migration
  def change
    create_table :headaches do |t|
      t.datetime :started
      t.datetime :ended
      t.integer :intensity
      t.string :headache_location
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
