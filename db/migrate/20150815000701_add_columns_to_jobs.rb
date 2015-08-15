class AddColumnsToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :employee_identifier, :string
    add_column :jobs, :department_name, :string
    add_column :jobs, :division_name, :string
  end
end
