# https://github.com/mattbeedle/usda-nutrient-database
require 'activerecord-import/base'
ActiveRecord::Import.require_adapter('postgresql')

UsdaNutrientDatabase.configure do |config|
  #config.batch_size = 20000 # import batch size, if using activerecord-import
  #config.perform_logging = true # default false
  #config.logger = Rails.logger # default Logger.new(STDOUT)
  #config.usda_version = 'sr25' # default sr28
end

