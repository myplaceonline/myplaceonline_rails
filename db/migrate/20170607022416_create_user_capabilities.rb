class CreateUserCapabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :user_capabilities do |t|
      t.integer :capability
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
