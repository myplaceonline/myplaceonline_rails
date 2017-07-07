class Food < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :food_name, presence: true
  
  child_properties(name: :food_ingredients, foreign_key: "parent_food_id")

  def display
    food_name
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :food_name,
      :notes,
      :calories,
      :price,
      :weight,
      :weight_type,
      food_ingredients_attributes: [
        :id,
        :_destroy,
        food_attributes: [
          :id,
          :_destroy,
          :food_name,
          :notes,
          :calories,
          :price,
          :weight,
          :weight_type
        ]
      ],
      food_files_attributes: FilesController.multi_param_names,
      food_nutrition_information_attributes: FoodNutritionInformation.params,
      food_information_attributes: [
        :id
      ]
    ]
  end

  child_files

  child_property(name: :food_nutrition_information, destroy_dependent: true)
  
  child_property(name: :food_information)

  def total_calories(quantity:)
    if !self.calories.nil?
      self.calories * quantity
    elsif !self.food_nutrition_information.nil? && !self.food_nutrition_information.calories_per_serving.nil?
      self.food_nutrition_information.calories_per_serving * quantity
    elsif !self.food_information.nil?
      self.food_information.calories * quantity
    else
      0
    end
  end
  
  def gram_weight
    result = nil
    if !self.weight.nil?
      if self.weight_type == Myp::FOOD_WEIGHT_CUPS && !self.food_information.nil? && !self.food_information.usda_weight.nil? && !self.food_information.usda_weight.gram_weight.nil?
        result = self.weight * self.food_information.usda_weight.gram_weight
      else
        case self.weight_type
        when Myp::FOOD_WEIGHT_GRAMS
          result = self.weight
        else
          raise "TODO"
        end
      end
    elsif !self.food_information.nil? && !self.food_information.usda_weight.nil? && !self.food_information.usda_weight.gram_weight.nil?
      result = self.food_information.usda_weight.gram_weight
    end
    result
  end

  def action_link
    Rails.application.routes.url_helpers.send("new_consumed_food_path", food_id: self.id)
  end
  
  def action_link_title
    I18n.t("myplaceonline.foods.consume_food")
  end
  
  def action_link_icon
    "check"
  end
end
