class CreateBankAccountFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :bank_account_files do |t|
      t.references :bank_account, foreign_key: true
      t.references :identity_file, foreign_key: true
      t.references :identity, foreign_key: true
      t.integer :position
      t.boolean :is_public

      t.timestamps
    end
  end
end
