class AddNameToPassports < ActiveRecord::Migration
  def change
    add_column :passports, :name, :string
  end
end
