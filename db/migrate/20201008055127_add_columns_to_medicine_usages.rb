class AddColumnsToMedicineUsages < ActiveRecord::Migration[5.2]
  def change
    add_column :medicine_usages, :description, :string
    add_column :medicine_usages, :usage_end, :datetime
  end
end
