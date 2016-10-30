class PerishableFoodsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["perishable_foods.updated_at DESC"]
    end

    def obj_params
      params.require(:perishable_food).permit(
        :purchased,
        :expires,
        :storage_location,
        :notes,
        :quantity,
        food_attributes: Food.params
      )
    end
end
