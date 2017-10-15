class SetWebsiteDomains < ActiveRecord::Migration[5.1]
  def change
    ExecutionContext.stack do
      Identity.where("user_id is not null").update_all(website_domain_id: Myp.website_domain.id)
    end
  end
end
