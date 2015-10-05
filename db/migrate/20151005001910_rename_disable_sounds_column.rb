class RenameDisableSoundsColumn < ActiveRecord::Migration
  def change
    rename_column :users, :disable_sounds, :enable_sounds
  end
end
