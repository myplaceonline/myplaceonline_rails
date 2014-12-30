class AddNotesColumnToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :notes, :text
  end
end
