class AddColumnsToDietFoods < ActiveRecord::Migration[5.1]
  def change
    add_column :diet_foods, :food_type, :integer
  end
end
