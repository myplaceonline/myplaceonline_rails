class AddColumnNotesToSongs < ActiveRecord::Migration[5.2]
  def change
    add_column :songs, :notes, :text
  end
end
