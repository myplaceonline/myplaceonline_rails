class AddUnitsToFoodNutrientInformations < ActiveRecord::Migration[5.1]
  def change
    MyplaceonlineExecutionContext.do_user(User.super_user) do
      FoodNutrientInformation.all.each do |fni|
        fni.nutrient_name = "#{fni.nutrient_name} (#{fni.usda_nutrient.units})"
        fni.save!
      end
    end
  end
end
