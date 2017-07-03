# This migration comes from usda_nutrient_database_engine (originally 7)
class CreateUsdaSourceCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :usda_source_codes do |t|
      t.string :code, null: false, index: true
      t.string :description, null: false
    end
  end
end
