class ConsumedFoodsController < MyplaceonlineController
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
end
