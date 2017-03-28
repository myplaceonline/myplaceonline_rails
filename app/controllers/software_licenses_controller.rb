class SoftwareLicensesController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(software_licenses.license_name) ASC"]
    end

    def obj_params
      params.require(:software_license).permit(
        :license_name,
        :license_value,
        :license_purchase_date,
        :license_key,
        :notes,
        software_license_files_attributes: FilesController.multi_param_names
      )
    end
end
