class AddTypeToDoctors < ActiveRecord::Migration
  def change
    add_column :doctors, :doctor_type, :integer
  end
end
