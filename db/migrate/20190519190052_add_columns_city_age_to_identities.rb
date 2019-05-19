class AddColumnsCityAgeToIdentities < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :current_city, :string
    add_column :identities, :explicit_age, :integer
  end
end
