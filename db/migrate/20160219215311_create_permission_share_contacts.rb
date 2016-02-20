class CreatePermissionShareContacts < ActiveRecord::Migration
  def change
    create_table :permission_share_contacts do |t|
      t.references :contact, index: true, foreign_key: true
      t.references :permission_share, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
