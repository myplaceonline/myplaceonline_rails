class CreateIdentityFileShares < ActiveRecord::Migration
  def change
    create_table :identity_file_shares do |t|
      t.references :identity_file, index: true, foreign_key: true
      t.references :share, index: true, foreign_key: true
      t.references :owner, index: true

      t.timestamps null: false
    end
  end
end
