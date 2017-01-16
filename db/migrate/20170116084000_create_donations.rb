class CreateDonations < ActiveRecord::Migration[5.0]
  def change
    create_table :donations do |t|
      t.string :donation_name
      t.date :donation_date
      t.decimal :amount, precision: 10, scale: 2
      t.references :location, foreign_key: true
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
