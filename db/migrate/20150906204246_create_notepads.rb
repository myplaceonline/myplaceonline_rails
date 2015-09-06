class CreateNotepads < ActiveRecord::Migration
  def change
    create_table :notepads do |t|
      t.string :title
      t.text :notepad_data
      t.references :owner, index: true

      t.timestamps
    end
  end
end
