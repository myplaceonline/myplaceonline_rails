class WarrantiesController < MyplaceonlineController
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.warranties.warranty_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(warranties.warranty_name)"]
    end

    def obj_params
      params.require(:warranty).permit(Warranty.params)
    end
    
    def has_category
      false
    end
end
