class CreateTaxDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :tax_documents do |t|
      t.string :tax_document_form_name
      t.string :tax_document_description
      t.text :notes
      t.date :received_date
      t.integer :fiscal_year
      t.decimal :amount, precision: 10, scale: 2
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
