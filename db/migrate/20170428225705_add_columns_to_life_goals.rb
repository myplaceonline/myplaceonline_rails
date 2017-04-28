class AddColumnsToLifeGoals < ActiveRecord::Migration[5.0]
  def change
    add_column :life_goals, :long_term, :boolean
  end
end
