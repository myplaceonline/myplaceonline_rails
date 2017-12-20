class CreatePaypalWebProfiles < ActiveRecord::Migration[5.1]
  def change
    create_table :paypal_web_profiles do |t|
      t.references :website_domain, foreign_key: true
      t.string :profile_id

      t.timestamps
    end
  end
end
