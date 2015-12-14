class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.string :token
      t.string :model_name
      t.integer :model_id
      t.references :owner, index: true

      t.timestamps
    end
  end
end
