class ImportUsdaFoods < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def change
    MyplaceonlineExecutionContext.do_user(User.super_user) do
      UsdaNutrientDatabase::Food.all.each do |food|
        FoodInformation.create!(
          identity_id: User.current_user.primary_identity_id,
          food_name: food.long_description,
          notes: food.short_description,
          usda_food: food
        )
      end
    end
  end
end
