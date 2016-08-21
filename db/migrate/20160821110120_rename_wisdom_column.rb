class RenameWisdomColumn < ActiveRecord::Migration
  def change
    rename_column :wisdoms, :wisdom, :notes
  end
end
