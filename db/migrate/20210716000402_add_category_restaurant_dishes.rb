class AddCategoryRestaurantDishes < ActiveRecord::Migration[6.1]
  def change
    Category.create(name: "restaurant_dishes", link: "restaurant_dishes", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/dish.png")
  end
end
