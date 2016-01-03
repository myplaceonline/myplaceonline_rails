class AddColumnsToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :new_years_resolution, :text
  end
end
