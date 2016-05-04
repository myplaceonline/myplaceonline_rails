class RecipesController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(recipes.name) ASC"]
    end

    def obj_params
      params.require(:recipe).permit(
        :name,
        :recipe,
        recipe_pictures_attributes: FilesController.multi_param_names
      )
    end
end
