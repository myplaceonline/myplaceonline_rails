class AddMgToSongs < ActiveRecord::Migration
  def change
    add_reference :songs, :musical_group, index: true
  end
end
