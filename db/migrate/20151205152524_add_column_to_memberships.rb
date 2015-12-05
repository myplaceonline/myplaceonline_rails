class AddColumnToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :membership_identifier, :string
  end
end
