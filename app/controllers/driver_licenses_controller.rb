class DriverLicensesController < MyplaceonlineController
  def may_upload
    true
  end
  
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_short_year(obj.driver_license_expires, User.current_user)
  end

  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.driver_licenses.driver_license_expires"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["driver_licenses.driver_license_expires"]
    end

    def obj_params
      params.require(:driver_license).permit(
        :driver_license_identifier,
        :driver_license_expires,
        :driver_license_issued,
        :region,
        :sub_region1,
        :notes,
        address_attributes: LocationsController.param_names,
        driver_license_files_attributes: FilesController.multi_param_names
      )
    end
end
