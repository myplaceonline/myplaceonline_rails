class AddColumn2ToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :experimental, :boolean
  end
end
