class LifeGoal < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :life_goal_name, presence: true
  
  def display
    Myp.appendstrwrap(life_goal_name, self.long_term ? I18n.t("myplaceonline.life_goals.long_term") : nil)
  end
end
