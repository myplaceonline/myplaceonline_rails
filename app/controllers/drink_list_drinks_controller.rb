class DrinkListDrinksController < MyplaceonlineController
  def path_name
    "drink_list_drink_list_drink"
  end

  def form_path
    "drink_list_drinks/form"
  end

  def nested
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.drink_list_drinks.drink_list"),
        link: drink_list_path(@parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.drink_list_drinks.drink_list"),
        link: drink_list_path(@obj.drink_list),
        icon: "back"
      }
    ] + super
  end
  
  protected
    def insecure
      true
    end

    def obj_params
      params.require(:drink_list_drink).permit(DrinkListDrink.params)
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      DrinkList
    end
end
