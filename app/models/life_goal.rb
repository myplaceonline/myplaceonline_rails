class LifeGoal < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :life_goal_name, presence: true
  
  def display
    life_goal_name
  end
end
