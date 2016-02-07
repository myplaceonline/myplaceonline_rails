class CompaniesController < MyplaceonlineController
  
  def self.param_names
    [
      :id,
      :_destroy,
      :name,
      :notes,
      location_attributes: LocationsController.param_names
    ]
  end

  def self.reject_if_blank(attributes)
    attributes.all?{|key, value|
      if key == "location_attributes"
        LocationsController.reject_if_blank(value)
      else
        value.blank?
      end
    }
  end

  protected
    def sorts
      ["lower(companies.name) ASC"]
    end
    
    def obj_params
      params.require(:company).permit(
        CompaniesController.param_names
      )
    end
end
