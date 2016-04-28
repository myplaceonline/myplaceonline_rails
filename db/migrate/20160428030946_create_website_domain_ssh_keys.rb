class CreateWebsiteDomainSshKeys < ActiveRecord::Migration
  def change
    create_table :website_domain_ssh_keys do |t|
      t.references :website_domain, index: true, foreign_key: true
      t.references :identity, index: true, foreign_key: true
      t.references :ssh_key, index: true, foreign_key: true
      t.string :username

      t.timestamps null: false
    end
  end
end
