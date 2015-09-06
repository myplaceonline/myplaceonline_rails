class CreatePointDisplays < ActiveRecord::Migration
  def change
    create_table :point_displays do |t|
      t.boolean :trash
      t.references :owner, index: true

      t.timestamps
    end
  end
end
