class AddCategoryAirlinePrograms < ActiveRecord::Migration[5.2]
  def change
    Category.create(name: "airline_programs", link: "airline_programs", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/plane.png", additional_filtertext: "flights rewards points")
  end
end
