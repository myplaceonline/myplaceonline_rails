class AddColumnHostToIdentities < ActiveRecord::Migration[5.1]
  def change
    add_reference :identities, :website_domain, references: :website_domains, foreign_key: false
    add_foreign_key :identities, :website_domains, column: :website_domain_id
  end
end
