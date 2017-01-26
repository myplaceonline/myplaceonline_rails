class DonationsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    if obj.donation_date.nil?
      nil
    else
      obj.donation_date.year.to_s
    end
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
