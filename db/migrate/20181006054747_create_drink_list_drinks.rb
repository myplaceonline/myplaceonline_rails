class CreateDrinkListDrinks < ActiveRecord::Migration[5.1]
  def change
    create_table :drink_list_drinks do |t|
      t.references :drink_list, foreign_key: true
      t.references :drink, foreign_key: true
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.boolean :is_public
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
