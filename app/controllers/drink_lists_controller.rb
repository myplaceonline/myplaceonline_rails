class DrinkListsController < MyplaceonlineController
  def footer_items_show
    result = super
    
    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.drink_lists.add_drink"),
        link: new_drink_list_drink_list_drink_path(@obj),
        icon: "plus"
      }
    end
    
    result << {
      title: I18n.t("myplaceonline.drink_lists.drinks"),
      link: drink_list_drink_list_drinks_path(@obj),
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
        [I18n.t("myplaceonline.drink_lists.drink_list_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["drink_lists.drink_list_name"]
    end

    def obj_params
      params.require(:drink_list).permit(
        :drink_list_name,
        :notes,
        drink_list_drinks_attributes: DrinkListDrink.params,
      )
    end
end
