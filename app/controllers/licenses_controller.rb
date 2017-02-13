class LicensesController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(licenses.license_name) ASC"]
    end

    def obj_params
      params.require(:license).permit(
        :license_name,
        :license_value,
        :license_purchase_date,
        :license_key,
        :notes,
        license_files_attributes: FilesController.multi_param_names
      )
    end
end
