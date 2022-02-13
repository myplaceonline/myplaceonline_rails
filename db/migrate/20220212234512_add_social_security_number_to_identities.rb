class AddSocialSecurityNumberToIdentities < ActiveRecord::Migration[6.1]
  def change
    add_column :identities, :ssn, :string
    add_reference :identities, :ssn_encrypted, index: true, foreign_key: false
    add_foreign_key :identities, :encrypted_values, column: :ssn_encrypted_id
  end
end
