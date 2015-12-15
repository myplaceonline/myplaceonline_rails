class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
