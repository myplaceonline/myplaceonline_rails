class AddColumnsToJobSalaries < ActiveRecord::Migration
  def change
    add_column :job_salaries, :new_title, :string
  end
end
