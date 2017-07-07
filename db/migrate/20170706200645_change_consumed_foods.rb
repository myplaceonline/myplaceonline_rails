class ChangeConsumedFoods < ActiveRecord::Migration[5.1]
  def change
    change_column :consumed_foods, :quantity, :decimal, :precision => 10, :scale => 2
  end
end
