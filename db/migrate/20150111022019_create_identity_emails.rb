class CreateIdentityEmails < ActiveRecord::Migration
  def change
    create_table :identity_emails do |t|
      t.string :email
      t.references :ref, index: true

      t.timestamps null: true
    end
  end
end
