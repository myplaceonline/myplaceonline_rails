class CreateSnps < ActiveRecord::Migration[5.1]
  def change
    create_table :snps do |t|
      t.string :snp_uid, index: true
      t.integer :snp_type
      t.integer :chromosome
      t.integer :position
      t.text :notes
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
