class FoodListFoodsController < MyplaceonlineController
  def path_name
    "food_list_food_list_food"
  end

  def form_path
    "food_list_foods/form"
  end

  def nested
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.food_list_foods.food_list"),
        link: food_list_path(@parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.food_list_foods.food_list"),
        link: food_list_path(@obj.food_list),
        icon: "back"
      }
    ] + super
  end
  
  protected
    def insecure
      true
    end

    def obj_params
      params.require(:food_list_food).permit(FoodListFood.params)
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      FoodList
    end
end
