class FoodNutritionInformationAmountsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["food_nutrition_information_amounts.updated_at DESC NULLS LAST"]
    end

    def obj_params
      params.require(:food_nutrition_information_amount).permit(
        FoodNutritionInformationAmount.params
      )
    end
end
