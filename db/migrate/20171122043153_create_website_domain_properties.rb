class CreateWebsiteDomainProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :website_domain_properties do |t|
      t.references :website_domain, foreign_key: true
      t.string :property_key
      t.text :property_value
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
