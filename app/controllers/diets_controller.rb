class DietsController < MyplaceonlineController
  
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:main]

  DEFAULT_EVALUATION_DAYS = 1
  
  DEFAULT_EVALUATION_DAYS_NAME = :default_evaluation_days
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.diets.evaluate"),
        link: diet_evaluate_path(@obj),
        icon: "search"
      },
      {
        title: I18n.t("myplaceonline.diets.consume"),
        link: diet_consume_path(@obj),
        icon: "check"
      },
    ] + super
  end
  
  def evaluate
    set_obj
    
    @days = Myp.param_integer(
      params,
      :days,
      default_value: Setting.get_value_integer(
        category: self.category,
        name: DEFAULT_EVALUATION_DAYS_NAME,
        default_value: 1
      )
    )
    
    tz = ActiveSupport::TimeZone[User.current_user.timezone]
    
    @start_day = params[:start_day]
    if @start_day.blank?
      @start_day = tz.now.beginning_of_day.to_date.to_s
    end
    
    if @days < 1
      @days = 1
    end

    @end_day = tz.parse(@start_day)
    @start_day = tz.parse(@start_day) - (@days - 1).days
    
    @consumed_foods = ConsumedFood.where(
      "identity_id = ? and consumed_food_time >= ?",
      User.current_user.current_identity_id,
      @start_day
    )
    
    @total_requirements = {}
    
    @total_consumed_foods = {}
    
    @total_calories = 0.0
    @consumed_foods.each do |consumed_food|
      
      if params[:only].blank? || params[:only].to_i == consumed_food.food.id
        consumed_food_calories = consumed_food.food.total_calories(quantity: consumed_food.quantity_with_fallback)
        
        @total_calories = @total_calories + consumed_food_calories
        
        total_consumed_food = @total_consumed_foods[consumed_food.food.id]
        if total_consumed_food.nil?
          total_consumed_food = {
            quantity: 0,
            consumed_food: consumed_food,
            calories: 0
          }
          @total_consumed_foods[consumed_food.food.id] = total_consumed_food
        end
        
        total_consumed_food[:quantity] = total_consumed_food[:quantity] + consumed_food.quantity_with_fallback
        total_consumed_food[:calories] = total_consumed_food[:calories] + consumed_food_calories
      end
      
    end

    @obj.dietary_requirements_collection.dietary_requirements.each do |req|
      total_req = @total_requirements[req.dietary_requirement_name]
      if total_req.nil?
        total_req = {
          needed: 0.0,
          consumed: 0.0,
          details: req # Assume multiple same by name
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
    
    @total_requirements.each do |k, total_req|
      
      Rails.logger.debug{"DietsController.evaluate requirement key: #{k}, value: #{total_req}"}
      
      food_nutrient_information = nil
      
      @consumed_foods.each do |consumed_food|
        
        if params[:only].blank? || params[:only].to_i == consumed_food.food.id
          Rails.logger.debug{"DietsController.evaluate consumed food: #{consumed_food.display}"}
        
          if !consumed_food.food.food_nutrition_information.nil?
            consumed_food.food.food_nutrition_information.food_nutrition_information_amounts.each do |fnia|
              if fnia.nutrient.nutrient_name.downcase == k.downcase
                if !fnia.nutrient.measurement_type.nil? && total_req[:details].dietary_requirement_type != fnia.nutrient.measurement_type
                  raise "Unmatched nutrient types for #{fnia.nutrient.nutrient_name} (#{total_req[:details].dietary_requirement_type} vs. #{fnia.nutrient.measurement_type})"
                end
                
                Rails.logger.debug{"DietsController.evaluate name: #{fnia.nutrient.nutrient_name}, quantity: #{consumed_food.quantity_with_fallback}, amount: #{fnia.amount}"}
                
                if fnia.measurement_type == FoodNutritionInformationAmount::MEASUREMENT_TYPE_PERCENT
                  # "Percent Daily Values are based on a 2,000 calorie diet."
                  
                  needed_per_day = total_req[:needed] / @days

                  calories_consumed_per_day = @total_calories / @days
                  
                  if calories_consumed_per_day < 2000.0
                    calories_consumed_per_day = 2000.0
                  end
                  
                  needed_per_day_adjusted = needed_per_day * (calories_consumed_per_day / 2000.0)
                  
                  Rails.logger.debug{"DietsController.evaluate percent needed_per_day: #{needed_per_day}, calories_consumed_per_day: #{calories_consumed_per_day}, needed_per_day_adjusted: #{needed_per_day_adjusted}"}
                  
                  total_req[:consumed] = total_req[:consumed] + (consumed_food.quantity_with_fallback * needed_per_day_adjusted * (fnia.amount / 100.0))
                else
                  total_req[:consumed] = total_req[:consumed] + (consumed_food.quantity_with_fallback * fnia.amount)
                end
              else
                # TODO display skipped warnings
              end
            end
          end
          
          if !consumed_food.food.food_information.nil? && !consumed_food.food.food_information.usda_food.nil?
            # First match up the nutrient
            if food_nutrient_information.nil?
              Rails.logger.debug{"DietsController.evaluate looking up #{k} for #{consumed_food.food.food_information.inspect} and #{consumed_food.food.food_information.usda_food.inspect}"}
              
              food_nutrient_information = FoodNutrientInformation.where(nutrient_name: k).take
            end
            
            if !food_nutrient_information.nil?
              usda_food = consumed_food.food.food_information.usda_food
              
              fn_index = usda_food.foods_nutrients.find_index do |fn|
                fn.nutrient_number == food_nutrient_information.usda_nutrient_nutrient_number
              end
              
              if !fn_index.nil?
                fn = usda_food.foods_nutrients[fn_index]
                amount_in_nutrient_type = consumed_food.quantity_with_fallback * fn.nutrient_value * (consumed_food.food.gram_weight / 100.0)
                
                Rails.logger.debug{"DietsController.evaluate usda_food: #{usda_food.nutrient_databank_number}, usda_nutrient: #{food_nutrient_information.usda_nutrient_nutrient_number}, quantity: #{consumed_food.quantity_with_fallback}, nutrient_value: #{fn.nutrient_value}, weight: #{consumed_food.food.gram_weight} g, weight/100: #{(consumed_food.food.gram_weight / 100.0)}, nutrient_units: #{food_nutrient_information.nutrient_units}"}
                
                if food_nutrient_information.nutrient_units != total_req[:details].nutrient_units
                  raise "TODO"
                end
                total_req[:consumed] = total_req[:consumed] + amount_in_nutrient_type
              end
            end
          end
        end
        
      end
    end
    
    @total_calories_per_day = (@total_calories / @days).to_i
    @total_calories = @total_calories.to_i
  end
  
  def consume
    set_obj
    
    @diet_foods = @obj.diet_foods
    
    if request.post?
      foods_consumed = 0
      
      params.each do |key, value|
        if key.start_with?("diet_food_")
          diet_food_id = key[10..-1].to_i
          diet_food = DietFood.where(id: diet_food_id, identity_id: User.current_user.current_identity_id).take!
          ConsumedFood.create!(
            identity_id: User.current_user.current_identity_id,
            consumed_food_time: User.current_user.time_now,
            food_id: diet_food.food_id,
            quantity: diet_food.quantity
          )
          foods_consumed = foods_consumed + 1
        end
      end
      
      redirect_to(obj_path, notice: I18n.t("myplaceonline.diets.consumed_items", count: foods_consumed))
    end
  end
  
  def main
    redirect_to(diet_path(self.all.take(1)))
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
    
    def settings_fields
      super + [
        {
          type: Myp::FIELD_TEXT,
          name: DEFAULT_EVALUATION_DAYS_NAME,
          value: @default_evaluation_days,
          placeholder: "myplaceonline.diets.default_evaluation_days"
        },
      ]
    end

    def load_settings_params
      super
      @default_evaluation_days = settings_string(name: DEFAULT_EVALUATION_DAYS_NAME, default_value: DEFAULT_EVALUATION_DAYS.to_s)
    end
end
