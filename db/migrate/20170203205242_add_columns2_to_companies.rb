class AddColumns2ToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_reference :companies, :company_identity, foreign_key: false
    add_foreign_key :companies, :identities, column: :company_identity_id
  end
end
