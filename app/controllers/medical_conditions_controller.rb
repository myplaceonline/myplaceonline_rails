class MedicalConditionsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.medical_conditions.medical_condition_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(medical_conditions.medical_condition_name)"]
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
        ],
        medical_condition_treatments_attributes: [
          :id,
          :_destroy,
          :treatment_date,
          :treatment_description,
          :notes,
          doctor_attributes: DoctorsController.param_names,
          location_attributes: LocationsController.param_names
        ],
        medical_condition_evaluations_attributes: MedicalConditionEvaluation.params,
        medical_condition_files_attributes: FilesController.multi_param_names
      )
    end
end
