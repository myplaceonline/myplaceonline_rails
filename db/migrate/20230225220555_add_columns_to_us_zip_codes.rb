class AddColumnsToUsZipCodes < ActiveRecord::Migration[6.1]
  def change
    add_column :us_zip_codes, :households, :integer
    add_column :us_zip_codes, :mean_income, :integer
  end
end
