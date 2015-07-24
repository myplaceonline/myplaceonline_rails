class AddGiftIdeasToContacts < ActiveRecord::Migration
  def change
    add_column :identities, :gift_ideas, :text
  end
end
