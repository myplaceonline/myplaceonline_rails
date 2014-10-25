class AddPointsToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :points, :integer
  end
end
