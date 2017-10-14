class BloodConcentrationsController < MyplaceonlineController
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.blood_concentrations.concentration_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(blood_concentrations.concentration_name)"]
    end

    def obj_params
      params.require(:blood_concentration).permit(BloodConcentration.params)
    end
    
    def has_category
      false
    end
end
