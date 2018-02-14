class FoodsController < MyplaceonlineController
  def may_upload
    true
  end

  def footer_items_show
    result = []
    
    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.foods.consume_food"),
        link: new_consumed_food_path(food_id: @obj.id),
        icon: "check"
      }
    end
      
    result + super
  end
  
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.foods.food_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(foods.food_name)"]
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
      remove_ids = FoodIngredient.where(identity_id: current_user.current_identity.id).map{|fi| fi.food_id}
      @objs = @objs.to_a.delete_if{|f| remove_ids.find_index(f.id) }
    end
end
