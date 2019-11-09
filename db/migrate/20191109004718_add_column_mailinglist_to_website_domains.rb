class AddColumnMailinglistToWebsiteDomains < ActiveRecord::Migration[5.2]
  def change
    add_reference :website_domains, :mailing_list, foreign_key: false
    add_foreign_key :website_domains, :groups, column: :mailing_list_id
  end
end
