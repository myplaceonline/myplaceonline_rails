class CreateCompanyInteractions < ActiveRecord::Migration[5.0]
  def change
    create_table :company_interactions do |t|
      t.references :company, foreign_key: true
      t.date :company_interaction_date
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
