class DropSnpColumns2 < ActiveRecord::Migration[5.1]
  def change
    remove_column :snps, :identity_id
    remove_column :snps, :snp_type
  end
end
