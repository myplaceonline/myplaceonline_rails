class AddIconToVehicles < ActiveRecord::Migration
  def change
    set_icon("vehicles", "famfamfam/car.png")
  end

  def set_icon(name, icon)
    c = Category.where(name: name).first
    if !c.nil?
      c.icon = icon
      c.save!
    end
  end
end
