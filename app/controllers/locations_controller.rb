class LocationsController < MyplaceonlineController
  def self.param_names(include_website: true, include_company: true)
    Myp.combine_conditionally([
      :id,
      :_destroy,
      :name,
      :address1,
      :address2,
      :address3,
      :region,
      :sub_region1,
      :sub_region2,
      :postal_code,
      :notes,
      :latitude,
      :longitude,
      location_phones_attributes: [:id, :number, :_destroy],
      location_pictures_attributes: FilesController.multi_param_names
    ], include_website) {[
      website_attributes: WebsitesController.param_names(include_website: include_website, include_company: include_company)
    ]}
  end
  
  def may_upload
    true
  end

  protected
    def sorts
      ["lower(locations.name) ASC"]
    end

    def obj_params
      params.require(:location).permit(
        LocationsController.param_names
      )
    end
end
