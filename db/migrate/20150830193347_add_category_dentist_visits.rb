class AddCategoryDentistVisits < ActiveRecord::Migration
  def change
    Category.create(name: "dentist_visits", link: "dentist_visits", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/tooth.png")
  end
end
