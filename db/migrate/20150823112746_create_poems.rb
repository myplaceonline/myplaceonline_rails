class CreatePoems < ActiveRecord::Migration
  def change
    create_table :poems do |t|
      t.string :poem_name
      t.text :poem
      t.references :owner, index: true

      t.timestamps
    end
  end
end
