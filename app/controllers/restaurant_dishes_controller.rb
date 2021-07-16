class RestaurantDishesController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_currency(obj.cost)
  end

  def path_name
    "restaurant_restaurant_dish"
  end

  def form_path
    "restaurant_dishes/form"
  end

  def nested
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.restaurant_dishes.back"),
        link: restaurant_path(@parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.restaurant_dishes.back"),
        link: restaurant_path(@obj.restaurant),
        icon: "back"
      }
    ] + super
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
        [I18n.t("myplaceonline.test_objects.dish_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["restaurant_dishes.dish_name"]
    end

    def obj_params
      params.require(:restaurant_dish).permit(RestaurantDish.params)
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      Restaurant
    end
end
