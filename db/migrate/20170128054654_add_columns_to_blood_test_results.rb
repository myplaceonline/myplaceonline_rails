class AddColumnsToBloodTestResults < ActiveRecord::Migration[5.0]
  def change
    add_column :blood_test_results, :flag, :integer
  end
end
