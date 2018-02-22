class AddColumnXRayToDentistVisits < ActiveRecord::Migration[5.1]
  def change
    add_column :dentist_visits, :xrays_taken, :boolean
  end
end
