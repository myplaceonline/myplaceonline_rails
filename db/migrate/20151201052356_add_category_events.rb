class AddCategoryEvents < ActiveRecord::Migration
  def change
    Category.create(name: "events", link: "events", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/calendar_view_day.png")
  end
end
