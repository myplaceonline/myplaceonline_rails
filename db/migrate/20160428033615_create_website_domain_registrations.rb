class CreateWebsiteDomainRegistrations < ActiveRecord::Migration
  def change
    create_table :website_domain_registrations do |t|
      t.references :website_domain, index: true, foreign_key: true
      t.references :repeat, index: true, foreign_key: true
      t.references :periodic_payment, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
