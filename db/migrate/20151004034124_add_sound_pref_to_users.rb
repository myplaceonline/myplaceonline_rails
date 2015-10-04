class AddSoundPrefToUsers < ActiveRecord::Migration
  def change
    add_column :users, :disable_sounds, :boolean
  end
end
