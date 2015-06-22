class AddContactTypeToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :contact_type, :integer
  end
end
