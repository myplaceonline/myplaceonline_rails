class FoodNutritionInformationAmountsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def obj_params
      params.require(:food_nutrition_information_amount).permit(
        FoodNutritionInformationAmount.params
      )
    end
end
