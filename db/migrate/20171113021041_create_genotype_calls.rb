class CreateGenotypeCalls < ActiveRecord::Migration[5.1]
  def change
    create_table :genotype_calls do |t|
      t.references :snp, foreign_key: true
      t.integer :allele1
      t.integer :allele2
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
