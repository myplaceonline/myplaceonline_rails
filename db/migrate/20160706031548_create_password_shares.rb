class CreatePasswordShares < ActiveRecord::Migration
  def change
    create_table :password_shares do |t|
      t.references :password, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.string :unencrypted_password

      t.timestamps null: false
    end
  end
end
