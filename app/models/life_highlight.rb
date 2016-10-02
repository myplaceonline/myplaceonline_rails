class LifeHighlight < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :life_highlight_name, presence: true
  
  def display
    life_highlight_name
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.life_highlight_time = User.current_user.time_now
    result
  end
end
