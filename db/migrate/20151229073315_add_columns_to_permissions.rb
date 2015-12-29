class AddColumnsToPermissions < ActiveRecord::Migration
  def change
    add_reference :permissions, :user, index: true, foreign_key: true
  end
end
