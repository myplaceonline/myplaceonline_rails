class AddCategoryMovies < ActiveRecord::Migration
  def change
    Category.create(name: "movies", link: "movies", position: 0, parent: Category.find_by_name("joy"))
  end
end
