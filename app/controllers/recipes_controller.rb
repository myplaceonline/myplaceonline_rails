class RecipesController < MyplaceonlineController
  def may_upload
    true
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
        recipe_pictures_attributes: FilesController.multi_param_names
      )
    end
end
