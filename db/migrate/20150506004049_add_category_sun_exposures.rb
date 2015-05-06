class AddCategorySunExposures < ActiveRecord::Migration
  def change
    Category.create(name: "sun_exposures", link: "sun_exposures", position: 0, parent: Category.find_by_name("health"))
  end
end
