class CreateSiteContacts < ActiveRecord::Migration
  def change
    create_table :site_contacts do |t|
      t.string :name
      t.string :email
      t.string :subject
      t.text :body

      t.timestamps null: false
    end
  end
end
