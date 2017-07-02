class FoodNutritionInformationsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["food_nutrition_informations.updated_at DESC NULLS LAST"]
    end

    def obj_params
      params.require(:food_nutrition_information).permit(
        FoodNutritionInformation.params
      )
    end
end
