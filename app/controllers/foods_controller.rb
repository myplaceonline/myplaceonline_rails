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

    def before_all_actions
      @topedit = true
    end
    
    def filter_json_index_search()
      remove_ids = FoodIngredient.where(identity_id: current_user.primary_identity.id).map{|fi| fi.food_id}
      @objs = @objs.to_a.delete_if{|f| remove_ids.find_index(f.id) }
    end
end
