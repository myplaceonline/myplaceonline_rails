class AddColumnsToPrescriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :prescriptions, :refill_maximum, :integer
  end
end
