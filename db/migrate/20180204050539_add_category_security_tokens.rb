class AddCategorySecurityTokens < ActiveRecord::Migration[5.1]
  def change
    Category.create(name: "security_tokens", link: "security_tokens", position: 0, parent: Category.find_by_name("order"), icon: "FatCow_Icons16x16/security.png", experimental: true, additional_filtertext: "api")
  end
end
