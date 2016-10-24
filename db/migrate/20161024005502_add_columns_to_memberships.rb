class AddColumnsToMemberships < ActiveRecord::Migration
  def change
    add_reference :memberships, :password, index: true, foreign_key: true
  end
end
