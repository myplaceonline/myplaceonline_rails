class CreateIdentityPhones < ActiveRecord::Migration
  def change
    create_table :identity_phones do |t|
      t.string :number
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
