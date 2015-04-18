class RecipesController < MyplaceonlineController
  def model
    Recipe
  end

  def display_obj(obj)
    obj.name
  end

  protected
    def sorts
      ["lower(recipes.name) ASC"]
    end

    def obj_params
      params.require(:recipe).permit(:name, :recipe)
    end
end
