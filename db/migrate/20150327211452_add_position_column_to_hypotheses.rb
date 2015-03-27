class AddPositionColumnToHypotheses < ActiveRecord::Migration
  def change
    add_column :hypotheses, :position, :integer
  end
end
