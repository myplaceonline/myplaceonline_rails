class AddIssuingAuthorityToPassports < ActiveRecord::Migration
  def change
    add_column :passports, :issuing_authority, :string
  end
end
