class AddColumns2ToFoods < ActiveRecord::Migration[5.1]
  def change
    add_reference :foods, :food_nutrition_information, foreign_key: true
  end
end
