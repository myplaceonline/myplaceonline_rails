class AddColumnLocationToVaccines < ActiveRecord::Migration[6.1]
  def change
    add_reference :vaccines, :location, foreign_key: true
  end
end
