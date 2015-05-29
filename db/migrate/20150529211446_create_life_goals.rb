class CreateLifeGoals < ActiveRecord::Migration
  def change
    create_table :life_goals do |t|
      t.string :life_goal_name
      t.text :notes
      t.integer :position
      t.datetime :goal_started
      t.datetime :goal_ended
      t.references :identity, index: true

      t.timestamps
    end
  end
end
