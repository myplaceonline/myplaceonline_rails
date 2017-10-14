class DrinksController < MyplaceonlineController
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.drinks.drink_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(drinks.drink_name)"]
    end

    def obj_params
      params.require(:drink).permit(Drink.params)
    end
    
    def has_category
      false
    end
end
