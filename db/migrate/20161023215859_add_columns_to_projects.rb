class AddColumnsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :default_to_top, :boolean
  end
end
