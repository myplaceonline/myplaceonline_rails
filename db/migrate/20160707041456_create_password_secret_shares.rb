class CreatePasswordSecretShares < ActiveRecord::Migration
  def change
    create_table :password_secret_shares do |t|
      t.references :password_secret, index: true, foreign_key: true
      t.references :password_share, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.string :unencrypted_answer

      t.timestamps null: false
    end
  end
end
