class AddCompanyToContacts < ActiveRecord::Migration
  def change
    add_reference :identities, :company, index: true, foreign_key: true
  end
end
