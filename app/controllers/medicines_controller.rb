class MedicinesController < MyplaceonlineController
  def may_upload
    true
  end
  
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.medicines.medicine_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(medicines.medicine_name)"]
    end

    def obj_params
      params.require(:medicine).permit(Medicine.params)
    end
    
    def has_category
      false
    end
end
