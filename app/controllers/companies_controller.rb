class CompaniesController < MyplaceonlineController
  
  def model
    Company
  end

  def display_obj(obj)
    obj.name
  end
  
  def self.param_names
    [:name]
  end

  def self.reject_if_blank(attributes)
    attributes.all? {|key, value| value.blank?}
  end

  protected
    def sorts
      ["lower(companies.name) ASC"]
    end
    
    def obj_params
      params.require(:company).permit(
        CompaniesController.param_names,
        select_or_create_permit(:company, :location_attributes, LocationsController.param_names)
      )
    end
    
    def create_presave
      if !@obj.location.nil?
        @obj.location.identity = current_user.primary_identity
      end
    end
end
