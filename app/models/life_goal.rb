class LifeGoal < ActiveRecord::Base
  belongs_to :identity
  validates :life_goal_name, presence: true
  
  def display
    life_goal_name
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
