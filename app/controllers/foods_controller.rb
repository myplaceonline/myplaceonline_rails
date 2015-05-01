class FoodsController < MyplaceonlineController
  def model
    Food
  end

  def display_obj(obj)
    obj.food_name
  end

  protected
    def sorts
      ["lower(foods.food_name) ASC"]
    end

    def obj_params
      params.require(:food).permit(Food.params)
    end
    
    def has_category
      false
    end
end
