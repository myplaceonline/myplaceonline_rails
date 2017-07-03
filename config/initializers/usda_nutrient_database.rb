# https://github.com/mattbeedle/usda-nutrient-database
# https://www.ars.usda.gov/ARSUserFiles/80400525/Data/SR/SR28/sr28_doc.pdf
# UsdaNutrientDatabase::FoodGroup
# UsdaNutrientDatabase::Food
# UsdaNutrientDatabase::Nutrient
# UsdaNutrientDatabase::FoodsNutrient
# UsdaNutrientDatabase::Weight
# UsdaNutrientDatabase::SourceCode

# UsdaNutrientDatabase::Food -> foods_nutrients -> nutrient

require 'activerecord-import/base'
ActiveRecord::Import.require_adapter('postgresql')

UsdaNutrientDatabase.configure do |config|
  #config.batch_size = 20000 # import batch size, if using activerecord-import
  #config.perform_logging = true # default false
  #config.logger = Rails.logger # default Logger.new(STDOUT)
  #config.usda_version = 'sr25' # default sr28
end
