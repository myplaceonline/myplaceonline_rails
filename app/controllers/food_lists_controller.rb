class FoodListsController < MyplaceonlineController
  def footer_items_show
    result = super
    
    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.food_lists.add_food"),
        link: new_food_list_food_list_food_path(@obj),
        icon: "plus"
      }
    end
    
    result << {
      title: I18n.t("myplaceonline.food_lists.foods"),
      link: food_list_food_list_foods_path(@obj),
      icon: "bars"
    }
    
    result
  end
  
  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.food_lists.food_list_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["food_lists.food_list_name"]
    end

    def obj_params
      params.require(:food_list).permit(
        :food_list_name,
        :notes,
        food_list_foods_attributes: FoodListFood.params,
      )
    end
end
