class AddColumns2ToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :document_date, :date
  end
end
