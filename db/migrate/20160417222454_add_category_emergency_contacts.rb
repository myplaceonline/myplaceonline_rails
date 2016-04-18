class AddCategoryEmergencyContacts < ActiveRecord::Migration
  def change
    Category.create(name: "emergency_contacts", link: "emergency_contacts", position: 0, parent: Category.find_by_name("health"), icon: "FatCow_Icons16x16/life_vest.png")
  end
end
