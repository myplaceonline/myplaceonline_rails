class CompaniesController < MyplaceonlineController
  
  def self.param_names(include_website: true)
    [
      :id,
      :_destroy,
      :name,
      :notes,
      location_attributes: LocationsController.param_names(include_website: include_website)
    ]
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
