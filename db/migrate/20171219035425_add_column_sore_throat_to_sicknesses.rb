class AddColumnSoreThroatToSicknesses < ActiveRecord::Migration[5.1]
  def change
    add_column :sicknesses, :sore_throat, :boolean
  end
end
