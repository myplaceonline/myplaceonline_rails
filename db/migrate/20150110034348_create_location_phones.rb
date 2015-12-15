class CreateLocationPhones < ActiveRecord::Migration
  def change
    create_table :location_phones do |t|
      t.string :number
      t.references :location, index: true

      t.timestamps null: true
    end
  end
end
