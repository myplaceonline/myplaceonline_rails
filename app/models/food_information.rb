class FoodInformation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  
  NUTRIENT_NUMBER_PROTEIN = "203"
  NUTRIENT_NUMBER_TOTAL_FAT = "204"
  NUTRIENT_NUMBER_CARBOHYDRATES = "205"

  def self.properties
    [
      { name: :food_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

  belongs_to :usda_food, class_name: "UsdaNutrientDatabase::Food", foreign_key: :usda_food_nutrient_databank_number
  belongs_to :usda_weight, class_name: "UsdaNutrientDatabase::Weight", foreign_key: [:usda_weight_nutrient_databank_number, :usda_weight_sequence_number]

  validates :food_name, presence: true
  
  def display
    food_name
  end
  
  def weight_types
    if self.usda_food.nil?
      nil
    else
      self.usda_food.weights.map{|x| [x.amount == 1 ? "#{x.amount} #{x.measurement_description}" : "#{x.amount} #{x.measurement_description.pluralize}", x.sequence_number.to_i]}
    end
  end
  
  def calories(weight_type:)
    weight_index = self.usda_food.weights.index{|x| x.sequence_number.to_i == weight_type}
    weight = self.usda_food.weights[weight_index]
    
    protein = 0
    protein_factor = 0
    if !self.usda_food.protein_factor.nil?
      protein_factor = self.usda_food.protein_factor
    end
    
    total_fat = 0
    total_fat_factor = 0
    if !self.usda_food.fat_factor.nil?
      total_fat_factor = self.usda_food.fat_factor
    end
    
    carbohydrates = 0
    carbohydrates_factor = 0
    if !self.usda_food.carbohydrate_factor.nil?
      carbohydrates_factor = self.usda_food.carbohydrate_factor
    end
    
    self.usda_food.foods_nutrients.each do |x|
      if x.nutrient_number == NUTRIENT_NUMBER_PROTEIN
        protein = x.nutrient_value
      elsif x.nutrient_number == NUTRIENT_NUMBER_TOTAL_FAT
        total_fat = x.nutrient_value
      elsif x.nutrient_number == NUTRIENT_NUMBER_CARBOHYDRATES
        carbohydrates = x.nutrient_value
      end
    end
    per_100 = weight.gram_weight / 100.0
    (protein * per_100 * protein_factor) + (total_fat * per_100 * total_fat_factor) + (carbohydrates * per_100 * carbohydrates_factor)
  end
end
