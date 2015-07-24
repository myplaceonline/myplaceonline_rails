class AddLikesToContacts < ActiveRecord::Migration
  def change
    add_column :identities, :likes, :text
  end
end
