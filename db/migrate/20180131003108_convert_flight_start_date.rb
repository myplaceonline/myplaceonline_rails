class ConvertFlightStartDate < ActiveRecord::Migration[5.1]
  def change
    change_column :flights, :flight_start_date, :datetime
  end
end
