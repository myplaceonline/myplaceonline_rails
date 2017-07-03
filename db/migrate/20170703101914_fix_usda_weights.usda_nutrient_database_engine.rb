# This migration comes from usda_nutrient_database_engine (originally 11)
class FixUsdaWeights < ActiveRecord::Migration[5.1]
  def change
    remove_column :usda_weights, :id

    change_table :usda_weights do |t|
      t.remove_index :nutrient_databank_number

      t.index [
        :nutrient_databank_number,
        :sequence_number
      ], {
        name: "uw_for_ndn_sn",
        unique: true
      }
    end
  end
end
