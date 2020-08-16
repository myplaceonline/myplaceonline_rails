class AddCategorySportsCourts < ActiveRecord::Migration[5.2]
  def change
    Category.create(name: "basketball_courts", link: "basketball_courts", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/sport_basketball.png")
    Category.create(name: "tennis_courts", link: "tennis_courts", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/sport_tennis.png")
    Category.create(name: "soccer_fields", link: "soccer_fields", position: 0, parent: Category.find_by_name("joy"), icon: "FatCow_Icons16x16/sport_soccer.png")
  end
end
