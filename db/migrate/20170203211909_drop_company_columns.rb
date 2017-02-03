class DropCompanyColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :companies, :name
    remove_column :companies, :notes
    remove_column :companies, :location_id
  end
end
