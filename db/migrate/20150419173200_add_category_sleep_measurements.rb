class AddCategorySleepMeasurements < ActiveRecord::Migration
  def change
    Category.create(name: "sleep_measurements", link: "sleep_measurements", position: 0, parent: Category.find_by_name("health"))
  end
end
