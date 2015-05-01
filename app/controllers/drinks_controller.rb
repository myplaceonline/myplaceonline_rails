class DrinksController < MyplaceonlineController
  def model
    Drink
  end

  def display_obj(obj)
    obj.display
  end

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
