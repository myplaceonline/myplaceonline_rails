class CreateBusinessCards < ActiveRecord::Migration
  def change
    create_table :business_cards do |t|
      t.references :contact, index: true, foreign_key: true
      t.text :notes
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
