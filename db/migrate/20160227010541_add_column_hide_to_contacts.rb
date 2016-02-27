class AddColumnHideToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :hide, :boolean
  end
end
