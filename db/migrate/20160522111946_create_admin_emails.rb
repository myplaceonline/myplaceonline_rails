class CreateAdminEmails < ActiveRecord::Migration
  def change
    create_table :admin_emails do |t|
      t.references :email, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.string :send_only_to
      t.string :exclude_emails

      t.timestamps null: false
    end
  end
end
