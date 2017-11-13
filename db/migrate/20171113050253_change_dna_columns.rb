class ChangeDnaColumns < ActiveRecord::Migration[5.1]
  def change
    change_column :snps, :chromosome, :integer, limit: 1
    change_column :genotype_calls, :orientation, :integer, limit: 1
    change_column :genotype_calls, :allele1, :integer, limit: 1
    change_column :genotype_calls, :allele2, :integer, limit: 1
    rename_column :genotype_calls, :allele1, :variant1
    rename_column :genotype_calls, :allele2, :variant2
  end
end
