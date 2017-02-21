class AddColumnsToMemories < ActiveRecord::Migration[5.0]
  def change
    add_column :memories, :feeling, :integer
  end
end
