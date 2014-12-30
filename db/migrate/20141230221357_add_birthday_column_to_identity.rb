class AddBirthdayColumnToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :birthday, :date
  end
end
