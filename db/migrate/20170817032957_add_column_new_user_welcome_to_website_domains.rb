class AddColumnNewUserWelcomeToWebsiteDomains < ActiveRecord::Migration[5.1]
  def change
    add_column :website_domains, :new_user_welcome, :text
    add_column :website_domains, :about, :text
    add_column :website_domains, :mission_statement, :text
    add_column :website_domains, :faq, :text
  end
end
