class CreateDoctors < ActiveRecord::Migration
  def change
    create_table :doctors do |t|
      t.references :contact, index: true
      t.references :owner, index: true

      t.timestamps
    end
  end
end
