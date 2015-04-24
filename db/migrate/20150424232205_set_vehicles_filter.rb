class SetVehiclesFilter < ActiveRecord::Migration
  def change
    c = Category.where(name: "vehicles").first
    c.additional_filtertext = "cars"
    c.save!
  end
end
