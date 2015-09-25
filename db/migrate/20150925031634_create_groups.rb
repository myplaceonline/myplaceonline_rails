class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :group_name
      t.text :notes
      t.references :owner, index: true

      t.timestamps
    end
  end
end
