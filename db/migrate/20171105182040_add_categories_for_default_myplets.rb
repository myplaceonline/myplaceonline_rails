class AddCategoriesForDefaultMyplets < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "point_displays", link: "point_displays", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/check_box_uncheck.png", internal: true)
    Category.create(name: "myplaceonline_searches", link: "myplaceonline_searches", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/check_box_uncheck.png", internal: true)
    Category.create(name: "myplaceonline_quick_category_displays", link: "myplaceonline_quick_category_displays", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/check_box_uncheck.png", internal: true)
    Category.create(name: "calendars", link: "calendars", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/check_box_uncheck.png", internal: true)
  end
end
