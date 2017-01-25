class AddColumns2ToMovies < ActiveRecord::Migration[5.0]
  def change
    add_column :movies, :when_owned, :datetime
    add_column :movies, :when_discarded, :datetime
    add_column :movies, :media_type, :integer
    add_column :movies, :number_of_media, :integer
  end
end
