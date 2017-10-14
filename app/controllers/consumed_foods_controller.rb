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

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.consumed_foods.consumed_food_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["consumed_foods.consumed_food_time"]
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
