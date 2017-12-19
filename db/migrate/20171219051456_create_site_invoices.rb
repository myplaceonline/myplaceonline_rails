class CreateSiteInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :site_invoices do |t|
      t.datetime :invoice_time
      t.decimal :invoice_amount, precision: 10, scale: 2
      t.string :model_class
      t.integer :model_id
      t.integer :invoice_status
      t.text :notes
      t.integer :visit_count
      t.datetime :archived
      t.integer :rating
      t.boolean :is_public
      t.references :identity, foreign_key: true

      t.timestamps
    end
  end
end
