class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :ref, index: true
      t.references :identity, index: true

      t.timestamps null: true
    end
  end
end
