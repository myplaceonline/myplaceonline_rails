class CreatePresents < ActiveRecord::Migration[5.1]
  def change
    create_table :presents do |t|
      t.string :present_name
      t.date :present_given
      t.date :present_purchased
      t.decimal :present_amount, precision: 10, scale: 2
      t.references :contact, foreign_key: true
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.boolean :is_public
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
