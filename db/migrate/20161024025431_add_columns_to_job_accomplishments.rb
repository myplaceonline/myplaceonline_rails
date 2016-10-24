class AddColumnsToJobAccomplishments < ActiveRecord::Migration
  def change
    add_column :job_accomplishments, :major, :boolean
  end
end
