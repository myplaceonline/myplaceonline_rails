class AddDefunctToPasswords < ActiveRecord::Migration
  def change
    add_column :passwords, :defunct, :datetime
  end
end
