class CreateTreks < ActiveRecord::Migration
  def change
    create_table :treks do |t|
      t.references :location, index: true, foreign_key: true
      t.integer :rating
      t.text :notes
      t.integer :visit_count
      t.references :owner, index: true, foreign_key: false

      t.timestamps null: false
    end
    add_foreign_key :treks, :identities, column: :owner_id
  end
end
