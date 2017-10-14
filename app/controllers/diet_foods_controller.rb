class DietFoodsController < MyplaceonlineController
  def path_name
    "diet_diet_food"
  end

  def form_path
    "diet_foods/form"
  end

  def nested
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.diet_foods.back"),
        link: diet_path(@parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.diet_foods.back"),
        link: diet_path(@obj.diet),
        icon: "back"
      }
    ] + super
  end
  
  protected
    def insecure
      true
    end

    def obj_params
      params.require(:diet_food).permit(DietFood.params)
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      Diet
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.diet_foods.food_type"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["diet_foods.food_type", "lower(foods.food_name) ASC"]
    end
    
    def all_joins
      "INNER JOIN foods ON foods.id = diet_foods.food_id"
    end

    def all_includes
      :food
    end
end
