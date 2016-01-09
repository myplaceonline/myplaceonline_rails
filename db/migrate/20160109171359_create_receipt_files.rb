class CreateReceiptFiles < ActiveRecord::Migration
  def change
    create_table :receipt_files do |t|
      t.references :receipt, index: true, foreign_key: true
      t.references :identity_file, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
