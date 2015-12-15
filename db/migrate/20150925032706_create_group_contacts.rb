class CreateGroupContacts < ActiveRecord::Migration
  def change
    create_table :group_contacts do |t|
      t.references :owner, index: true
      t.references :group, index: true
      t.references :contact, index: true

      t.timestamps null: true
    end
  end
end
