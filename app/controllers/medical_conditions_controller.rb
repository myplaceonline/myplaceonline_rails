class MedicalConditionsController < MyplaceonlineController
  def model
    MedicalCondition
  end

  def display_obj(obj)
    obj.display
  end

  protected
    def sorts
      ["lower(medical_conditions.medical_condition_name) ASC"]
    end

    def obj_params
      params.require(:medical_condition).permit(:medical_condition_name, :notes)
    end
end
