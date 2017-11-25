class AddColumnRooftopToBars < ActiveRecord::Migration[5.1]
  def change
    add_column :bars, :rooftop, :boolean
  end
end
