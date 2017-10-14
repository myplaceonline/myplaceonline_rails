class NutrientsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.nutrients.nutrient_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(nutrients.nutrient_name)"]
    end

    def obj_params
      params.require(:nutrient).permit(
        Nutrient.params
      )
    end
end
