class AddColumnWebsiteDomainToInviteCodes < ActiveRecord::Migration[5.1]
  def change
    add_reference :invite_codes, :website_domain, foreign_key: true
  end
end
