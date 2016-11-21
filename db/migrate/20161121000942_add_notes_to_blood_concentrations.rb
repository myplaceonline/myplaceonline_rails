class AddNotesToBloodConcentrations < ActiveRecord::Migration
  def change
    add_column :blood_concentrations, :notes, :text
  end
end
