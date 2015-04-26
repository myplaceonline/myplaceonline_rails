class MealsController < MyplaceonlineController
  def model
    Meal
  end

  def display_obj(obj)
    Myp.display_datetime_short(obj.meal_time, User.current_user)
  end

  protected
    def sorts
      ["meals.meal_time DESC"]
    end

    def obj_params
      params.require(:meal).permit(
        :meal_time,
        :notes,
        :price,
        :calories,
        select_or_create_permit(:meal, :location_attributes, LocationsController.param_names),
        meal_foods_attributes: [
          :id,
          :_destroy,
          food_attributes: Food.params
        ]
      )
    end
    
    def new_obj_initialize
      @obj.meal_time = DateTime.now
    end
end
