class NutrientsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(nutrients.nutrient_name) ASC"]
    end

    def obj_params
      params.require(:nutrient).permit(
        Nutrient.params
      )
    end
end
