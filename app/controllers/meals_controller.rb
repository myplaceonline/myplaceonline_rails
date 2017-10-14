class MealsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.meals.meal_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["meals.meal_time"]
    end

    def obj_params
      params.require(:meal).permit(
        :meal_time,
        :notes,
        :price,
        :calories,
        location_attributes: LocationsController.param_names,
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
end
