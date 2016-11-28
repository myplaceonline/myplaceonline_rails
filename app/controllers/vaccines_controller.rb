class VaccinesController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(vaccines.vaccine_name) ASC"]
    end

    def obj_params
      params.require(:vaccine).permit(
        :vaccine_name,
        :vaccine_date,
        :notes,
        vaccine_files_attributes: FilesController.multi_param_names
      )
    end
end
