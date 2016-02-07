class AddColumns2ToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :sex_type, :integer
  end
end
