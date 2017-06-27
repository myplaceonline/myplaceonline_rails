class DietsController < MyplaceonlineController
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.diets.evaluate"),
        link: diet_evaluate_path(@obj),
        icon: "search"
      }
    ] + super
  end
  
  def evaluate
    set_obj
    
    @days = Myp.param_integer(params, :days, default_value: 1)
    
    @start = ActiveSupport::TimeZone[User.current_user.timezone].now.beginning_of_day - (@days - 1).days
  end
  
  protected
    def insecure
      true
    end

    def sorts
      ["lower(diets.diet_name) ASC"]
    end

    def obj_params
      params.require(:diet).permit(
        :diet_name,
        :notes,
        dietary_requirements_collection_attributes: DietaryRequirementsCollection.param_names,
        diet_foods_attributes: DietFood.params,
      )
    end
end
