class CreatePermissionShares < ActiveRecord::Migration
  def change
    create_table :permission_shares do |t|
      t.string :subject_class
      t.integer :subject_id
      t.string :subject
      t.text :body
      t.boolean :email
      t.boolean :copy_self
      t.references :share, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
