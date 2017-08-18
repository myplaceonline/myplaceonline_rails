class AddColumnBloodTypeToIdentities < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :blood_type, :integer
  end
end
