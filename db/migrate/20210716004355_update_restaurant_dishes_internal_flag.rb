class UpdateRestaurantDishesInternalFlag < ActiveRecord::Migration[6.1]
  def change
    cat = Category.where(name: "restaurant_dishes").take!
    cat.internal = true
    cat.save!
  end
end
