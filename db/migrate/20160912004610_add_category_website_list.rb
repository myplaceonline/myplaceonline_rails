class AddCategoryWebsiteList < ActiveRecord::Migration
  def change
    Category.create(name: "website_lists", link: "website_lists", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/domain_template.png")
  end
end
