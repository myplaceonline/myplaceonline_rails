class FoodInformationsController < MyplaceonlineController
  
  def index
    
    if Myp.param_bool(params, :remote_filter)
      @allobjs = FoodInformation.where(
        "identity_id = :identity_id and lower(food_name) LIKE :query",
        identity_id: User.super_user.current_identity_id,
        query: "%#{params[:q].downcase}%"
      ).order(sorts_wrapper)
    else
      @allobjs = FoodInformation.where(identity_id: User.super_user.current_identity_id).order(sorts_wrapper)
    end
    
    super
  end
  
  protected
    def sorts
      ["lower(food_informations.food_name) ASC"]
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
