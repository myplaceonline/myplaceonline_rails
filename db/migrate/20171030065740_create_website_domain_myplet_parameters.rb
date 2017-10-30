class CreateWebsiteDomainMypletParameters < ActiveRecord::Migration[5.1]
  def change
    create_table :website_domain_myplet_parameters do |t|
      t.references :website_domain_myplet, foreign_key: true, index: false
      t.string :name
      t.string :val
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
    add_index :website_domain_myplet_parameters, :website_domain_myplet_id, name: "wdmp_on_wdmi"
  end
end
