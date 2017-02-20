class AddCategoryHospitalVisits < ActiveRecord::Migration[5.0]
  def change
    Category.create(name: "hospital_visits", link: "hospital_visits", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/stethoscope.png")
  end
end
