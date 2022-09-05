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
      :bathroom_code,
      :allhours,
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
    def additional_sorts
      [
        [I18n.t("myplaceonline.locations.name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(locations.name)"]
    end

    def obj_params
      params.require(:location).permit(
        LocationsController.param_names
      )
    end

    def show_map?
      true
    end

    def has_location?(item)
      true
    end

    def get_map_location(item)
      item
    end
end
