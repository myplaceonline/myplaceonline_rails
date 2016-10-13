class CreateEmailAccounts < ActiveRecord::Migration
  def change
    create_table :email_accounts do |t|
      t.references :password, index: true, foreign_key: true
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
