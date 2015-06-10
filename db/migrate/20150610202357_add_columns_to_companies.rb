class AddColumnsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :notes, :text
  end
end
