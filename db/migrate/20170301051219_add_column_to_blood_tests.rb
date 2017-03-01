class AddColumnToBloodTests < ActiveRecord::Migration[5.0]
  def change
    add_column :blood_tests, :preceding_changes, :string
  end
end
