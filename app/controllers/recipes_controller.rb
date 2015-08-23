class RecipesController < MyplaceonlineController
  protected
    def sorts
      ["lower(recipes.name) ASC"]
    end

    def obj_params
      params.require(:recipe).permit(:name, :recipe)
    end
end
