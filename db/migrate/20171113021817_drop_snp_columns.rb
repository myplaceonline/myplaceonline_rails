class DropSnpColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :snps, :created_at
    remove_column :snps, :updated_at
    remove_column :snps, :notes
    remove_column :genotype_calls, :created_at
    remove_column :genotype_calls, :updated_at
  end
end
