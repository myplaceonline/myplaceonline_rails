class PerishableFoodsController < MyplaceonlineController
  def search_index_name
    Food.table_name
  end

  def search_parent_category
    category_name.singularize
  end

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

    def sorts
      ["foods.food_name ASC"]
    end
    
    def all_joins
      "INNER JOIN foods ON foods.id = perishable_foods.food_id"
    end

    def all_includes
      :food
    end
end
