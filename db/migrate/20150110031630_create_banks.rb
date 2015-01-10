class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.references :identity, index: true
      t.references :location, index: true
      t.references :password, index: true

      t.timestamps
    end
  end
end
