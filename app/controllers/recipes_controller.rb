class RecipesController < MyplaceonlineController
  def may_upload
    true
  end
  
  def simple_index_filters
    [
      { name: :bake },
      { name: :bbq },
      { name: :boil },
      { name: :grill },
      { name: :microwave },
      { name: :pan_fry },
      { name: :pressure },
      { name: :slow_cooker },
      { name: :smoke },
      { name: :sousvide },
      { name: :steam },
    ]
  end

  def index_filter_translate(name)
    "myplaceonline.recipes.recipe_types.#{name}"
  end

  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.recipes.name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(recipes.name)"]
    end

    def obj_params
      params.require(:recipe).permit(
        :name,
        :recipe,
        :recipe_category,
        :recipe_type,
        recipe_pictures_attributes: FilesController.multi_param_names
      )
    end
    
    def additional_sql_simple_index_filters(result)
      first = true
      simple_index_filters.each do |simple_index_filter|
        if instance_variable_get("@#{simple_index_filter[:name].to_s}")
          if first
            first = false
            result = "#{result} and (recipes.recipe_type = #{Myp.get_select_value(simple_index_filter[:name].to_s, Recipe::RECIPE_TYPES)}"
          else
            result = "#{result} or recipes.recipe_type = #{Myp.get_select_value(simple_index_filter[:name].to_s, Recipe::RECIPE_TYPES)}"
          end
        end
      end
      if !first
        result = result + ")"
      end
      return result
    end
end
