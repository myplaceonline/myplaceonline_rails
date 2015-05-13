class MedicinesController < MyplaceonlineController
  def model
    Medicine
  end

  def display_obj(obj)
    obj.medicine_name
  end

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
