class PrescriptionsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def sorts
      ["lower(prescriptions.prescription_name) ASC"]
    end

    def obj_params
      params.require(:prescription).permit(
        :prescription_name,
        :prescription_date,
        :notes,
        :refill_maximum,
        doctor_attributes: DoctorsController.param_names,
        prescription_files_attributes: FilesController.multi_param_names
      )
    end
end
