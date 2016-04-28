class CreateWebsiteDomains < ActiveRecord::Migration
  def change
    create_table :website_domains do |t|
      t.string :domain_name
      t.text :notes
      t.references :domain_host, index: true, foreign_key: false
      t.references :website, index: true, foreign_key: true
      t.integer :visit_count
      t.references :identity, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_foreign_key :website_domains, :memberships, column: :domain_host_id
  end
end
