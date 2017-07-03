# This migration comes from usda_nutrient_database_engine (originally 8)
class AddTimestampsToAllTables < ActiveRecord::Migration[5.1]
  def change
    [
      :usda_food_groups, :usda_foods, :usda_foods_nutrients,
      :usda_weights, :usda_footnotes, :usda_source_codes,
      :usda_nutrients
    ].each do |table_name|
      add_column table_name, :created_at, :datetime
      add_column table_name, :updated_at, :datetime
    end
  end
end
