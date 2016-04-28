class AddCategoryWebsiteDomains < ActiveRecord::Migration
  def change
    Category.create(name: "website_domains", link: "website_domains", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/domain_names_advanced.png", experimental: true)
  end
end
