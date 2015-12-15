class CreateEncryptedValues < ActiveRecord::Migration
  def change
    create_table :encrypted_values do |t|
      t.string :val
      t.binary :salt
      t.references :user, index: true

      t.timestamps null: true
    end
  end
end
