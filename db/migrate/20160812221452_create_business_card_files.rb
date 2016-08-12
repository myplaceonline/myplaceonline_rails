class CreateBusinessCardFiles < ActiveRecord::Migration
  def change
    create_table :business_card_files do |t|
      t.references :business_card, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
