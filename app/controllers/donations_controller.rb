class DonationsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(donations.donation_name) ASC"]
    end

    def obj_params
      params.require(:donation).permit(
        :donation_name,
        :donation_date,
        :amount,
        :notes,
        location_attributes: LocationsController.param_names,
        donation_files_attributes: FilesController.multi_param_names
      )
    end
end
