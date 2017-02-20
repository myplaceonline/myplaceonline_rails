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
    def sorts
      ["driver_licenses.driver_license_expires DESC"]
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
