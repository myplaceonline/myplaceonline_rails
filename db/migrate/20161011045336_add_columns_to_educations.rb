class AddColumnsToEducations < ActiveRecord::Migration
  def change
    add_column :educations, :degree_type, :integer
  end
end
