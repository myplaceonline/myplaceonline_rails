class CreateIdentityClothes < ActiveRecord::Migration[5.2]
  def change
    create_table :identity_clothes do |t|
      t.references :identity, foreign_key: true
      t.references :parent_identity, foreign_key: false
      t.datetime :archived
      t.integer :rating
      t.boolean :is_public
      t.date :when_date
      t.text :clothes

      t.timestamps
    end
    add_foreign_key :identity_clothes, :identities, column: :parent_identity_id
  end
end
