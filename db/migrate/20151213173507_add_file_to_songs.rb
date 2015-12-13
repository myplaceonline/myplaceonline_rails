class AddFileToSongs < ActiveRecord::Migration
  def change
    add_reference :songs, :identity_file, index: true
  end
end
