class CreateBoycotts < ActiveRecord::Migration[5.1]
  def change
    create_table :boycotts do |t|
      t.string :boycott_name
      t.date :boycott_start
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
