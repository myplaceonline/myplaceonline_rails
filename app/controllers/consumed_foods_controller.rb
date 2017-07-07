class ConsumedFoodsController < MyplaceonlineController
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_datetime_short(obj.consumed_food_time, User.current_user)
  end

  protected
    def insecure
      true
    end

    def sorts
      ["consumed_foods.consumed_food_time DESC NULLS LAST"]
    end

    def obj_params
      params.require(:consumed_food).permit(
        :consumed_food_time,
        :quantity,
        food_attributes: Food.params
      )
    end

    def new_prerespond
      if !params[:food_id].blank?
        Myp.set_existing_object(@obj, :food, Food, params[:food_id].to_i, action: :show)
      end
    end
end
