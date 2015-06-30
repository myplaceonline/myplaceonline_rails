class MedicalConditionsController < MyplaceonlineController
  def model
    MedicalCondition
  end

  protected
    def sorts
      ["lower(medical_conditions.medical_condition_name) ASC"]
    end

    def obj_params
      params.require(:medical_condition).permit(
        :medical_condition_name,
        :notes,
        medical_condition_instances_attributes: [
          :id,
          :_destroy,
          :condition_start,
          :condition_end,
          :notes
        ]
      )
    end
end
