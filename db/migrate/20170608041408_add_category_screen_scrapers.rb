class AddCategoryScreenScrapers < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "website_scrapers", link: "website_scrapers", position: 0, parent: Category.find_by_name("obscure"), icon: "FatCow_Icons16x16/domain_template.png", experimental: true)
  end
end
