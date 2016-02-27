class CreateEmailContacts < ActiveRecord::Migration
  def change
    create_table :email_contacts do |t|
      t.references :email, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.references :contact, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
