class MedicinesController < MyplaceonlineController
  protected
    def sorts
      ["lower(medicines.medicine_name) ASC"]
    end

    def obj_params
      params.require(:medicine).permit(Medicine.params)
    end
    
    def has_category
      false
    end
end
