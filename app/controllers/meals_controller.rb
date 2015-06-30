class MealsController < MyplaceonlineController
  def model
    Meal
  end

  protected
    def insecure
      true
    end

    def sorts
      ["meals.meal_time DESC"]
    end

    def obj_params
      params.require(:meal).permit(
        :meal_time,
        :notes,
        :price,
        :calories,
        Myp.select_or_create_permit(params[:meal], :location_attributes, LocationsController.param_names),
        meal_foods_attributes: [
          :id,
          :_destroy,
          :food_servings,
          food_attributes: Food.params
        ],
        meal_drinks_attributes: [
          :id,
          :_destroy,
          :drink_servings,
          drink_attributes: Drink.params
        ],
        meal_vitamins_attributes: [
          :id,
          :_destroy,
          vitamin_attributes: Vitamin.params
        ]
      )
    end
    
    def new_obj_initialize
      @obj.meal_time = DateTime.now
    end
end
