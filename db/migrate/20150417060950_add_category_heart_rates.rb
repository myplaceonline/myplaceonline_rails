class AddCategoryHeartRates < ActiveRecord::Migration
  def change
    Category.create(name: "heart_rates", link: "heart_rates", position: 0, parent: Category.find_by_name("health"))
  end
end
