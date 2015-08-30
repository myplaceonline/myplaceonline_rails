class AddCategoryDoctorVisits < ActiveRecord::Migration
  def change
    Category.create(name: "doctor_visits", link: "doctor_visits", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/bandaid.png")
  end
end
