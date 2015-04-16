class AddCategoryBloodPressures < ActiveRecord::Migration
  def change
    Category.create(name: "blood_pressures", link: "blood_pressures", position: 0, parent: Category.find_by_name("health"))
  end
end
