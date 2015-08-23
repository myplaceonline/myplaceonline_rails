class AddGenreToMusicalGroups < ActiveRecord::Migration
  def change
    add_column :musical_groups, :musical_genre, :string
  end
end
