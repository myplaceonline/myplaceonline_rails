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
    
    @consumed_foods = ConsumedFood.where(
      "identity_id = ? and consumed_food_time >= ?",
      User.current_user.primary_identity_id,
      @start
    )
    
    @total_requirements = {}
    
    @total_calories = 0.0
    @consumed_foods.each do |consumed_food|
      
      quantity = 1
      if !consumed_food.quantity.nil?
        quantity = consumed_food.quantity
      end
      @total_calories = @total_calories + (consumed_food.food.calories * quantity)
      
    end

    @obj.dietary_requirements_collection.dietary_requirements.each do |req|
      total_req = @total_requirements[req.dietary_requirement_name]
      if total_req.nil?
        total_req = {
          needed: 0.0,
          consumed: 0.0,
          details: req # Assume same by name
        }
        @total_requirements[req.dietary_requirement_name] = total_req
      end
      case req.dietary_requirement_context
      when DietaryRequirement::CONTEXT_PER_DAY
        total_req[:needed] = total_req[:needed] + (@days * req.dietary_requirement_amount)
      when DietaryRequirement::CONTEXT_PER_1000_CALORIES
        total_req[:needed] = total_req[:needed] + (req.dietary_requirement_amount * (@total_calories / 1000.0))
      else
        raise "TODO"
      end
    end
    
    @total_requirements.each do |k, v|
      @consumed_foods.each do |consumed_food|
        # nutrients
      end
    end
    
    @total_calories_per_day = (@total_calories / @days).to_i
    @total_calories = @total_calories.to_i
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
