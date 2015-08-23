class DrinksController < MyplaceonlineController
  protected
    def sorts
      ["lower(drinks.drink_name) ASC"]
    end

    def obj_params
      params.require(:drink).permit(Drink.params)
    end
    
    def has_category
      false
    end
end
