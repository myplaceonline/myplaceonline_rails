class FoodNutritionInformation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :serving_size, type: ApplicationRecord::PROPERTY_TYPE_DECIMAL },
      { name: :servings_per_container, type: ApplicationRecord::PROPERTY_TYPE_DECIMAL },
      { name: :calories_per_serving, type: ApplicationRecord::PROPERTY_TYPE_DECIMAL },
      { name: :calories_per_serving_from_fat, type: ApplicationRecord::PROPERTY_TYPE_DECIMAL },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :food_nutrition_file_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  def display
    I18n.t("myplaceonline.food_nutrition_informations.display")
  end

  child_files

  def self.params
    [
      :serving_size,
      :servings_per_container,
      :calories_per_serving,
      :calories_per_serving_from_fat,
      :notes,
      food_nutrition_information_files_attributes: FilesController.multi_param_names,
      food_nutrition_information_amounts_attributes: FoodNutritionInformationAmount.params,
    ]
  end
  
  child_property(name: :food)
  
  child_properties(name: :food_nutrition_information_amounts)
end
