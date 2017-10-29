class CreateWebsiteDomainMyplets < ActiveRecord::Migration[5.1]
  def change
    create_table :website_domain_myplets do |t|
      t.references :website_domain, foreign_key: true
      t.string :title
      t.references :category, foreign_key: true
      t.integer :x_coordinate
      t.integer :y_coordinate
      t.integer :border_type
      t.integer :position
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
