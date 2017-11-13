class AddColumnsToGenotypeCalls < ActiveRecord::Migration[5.1]
  def change
    add_reference :genotype_calls, :dna_analysis, foreign_key: true
  end
end
