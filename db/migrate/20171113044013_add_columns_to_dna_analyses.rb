class AddColumnsToDnaAnalyses < ActiveRecord::Migration[5.1]
  def change
    add_column :dna_analyses, :reference_genome, :string
  end
end
