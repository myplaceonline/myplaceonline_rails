class CreateCategoryPoints < ActiveRecord::Migration
  def change
    create_table :category_points do |t|
      t.references :identity, index: true
      t.references :category, index: true
      t.integer :count

      t.timestamps
    end
  end
end
