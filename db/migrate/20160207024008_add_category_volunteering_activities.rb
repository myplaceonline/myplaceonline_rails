class AddCategoryVolunteeringActivities < ActiveRecord::Migration
  def change
    Category.create(name: "volunteering_activities", link: "volunteering_activities", position: 0, parent: Category.find_by_name("meaning"), icon: "FatCow_Icons16x16/share.png")
  end
end
