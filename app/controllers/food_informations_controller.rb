class FoodInformationsController < MyplaceonlineController
  
  def index
    
    if Myp.param_bool(params, :remote_filter)
      @allobjs = FoodInformation.where(
        "identity_id = :identity_id and lower(food_name) LIKE :query",
        identity_id: User::SUPER_USER_IDENTITY_ID,
        query: "%#{params[:q].downcase}%"
      ).order(sorts_wrapper)
    else
      @allobjs = FoodInformation.where(identity_id: User::SUPER_USER_IDENTITY_ID).order(sorts_wrapper)
    end
    
    super
  end
  
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.food_informations.food_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(food_informations.food_name)"]
    end

    def obj_params
      params.require(:food_information).permit(
        :food_name
      )
    end

    def has_category
      false
    end

    def check_archived
      false
    end

    def before_show
      @nutrients = @obj.usda_food.foods_nutrients.to_a.dup.sort{|x, y| x.nutrient.nutrient_description <=> y.nutrient.nutrient_description}
    end
end
