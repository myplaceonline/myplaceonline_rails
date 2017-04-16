class CreateInsuranceCards < ActiveRecord::Migration[5.0]
  def change
    create_table :insurance_cards do |t|
      t.string :insurance_card_name
      t.date :insurance_card_start
      t.date :insurance_card_end
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
