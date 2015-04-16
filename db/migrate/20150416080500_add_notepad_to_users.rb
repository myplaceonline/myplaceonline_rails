class AddNotepadToUsers < ActiveRecord::Migration
  def change
    add_column :identities, :notepad, :text
  end
end
