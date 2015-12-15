class CreateMyplaceonlineQuickCategoryDisplays < ActiveRecord::Migration
  def change
    create_table :myplaceonline_quick_category_displays do |t|
      t.boolean :trash
      t.references :owner, index: true

      t.timestamps null: true
    end
  end
end
