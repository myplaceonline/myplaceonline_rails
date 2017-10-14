class FoodNutritionInformationsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def obj_params
      params.require(:food_nutrition_information).permit(
        FoodNutritionInformation.params
      )
    end
    
    def has_category
      false
    end
end
