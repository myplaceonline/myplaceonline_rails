class ReimportFoodInformations3 < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def change
    MyplaceonlineExecutionContext.do_user(User.super_user) do
      UsdaNutrientDatabase::Food.all.each do |food|
        food.weights.each do |food_weight|
          weight_type = food_weight.amount == 1 ? food_weight.measurement_description : food_weight.measurement_description.pluralize
          FoodInformation.create!(
            identity_id: User.current_user.primary_identity_id,
            food_name: "#{food.long_description} (#{Myp.decimal_to_s(value: food_weight.amount)} #{weight_type})",
            notes: food.short_description,
            usda_food_nutrient_databank_number: food.nutrient_databank_number,
            usda_weight_nutrient_databank_number: food_weight.nutrient_databank_number,
            usda_weight_sequence_number: food_weight.sequence_number,
          )
        end
      end
    end
  end
end
