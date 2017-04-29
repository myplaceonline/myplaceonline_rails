class ChangeDentalInsurancesColumn < ActiveRecord::Migration[5.0]
  def change
    remove_column :dental_insurances, :archived
    add_column :dental_insurances, :archived, :datetime
  end
end
