class AddColumnsToContacts < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :contact_preference, :integer
  end
end
