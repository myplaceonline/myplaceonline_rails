class CreateApartments < ActiveRecord::Migration
  def change
    create_table :apartments do |t|
      t.references :location, index: true
      t.references :identity, index: true

      t.timestamps
    end
  end
end
