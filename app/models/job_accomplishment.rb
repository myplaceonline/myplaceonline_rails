class JobAccomplishment < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :job
  
  validates :accomplishment_time, presence: true
  validates :accomplishment_title, presence: true

  def display
    Myp.appendstrwrap(Myp.display_datetime(self.accomplishment_time, User.current_user), Myp.ellipses_if_needed(self.accomplishment_title, 16))
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.accomplishment_time = User.current_user.time_now
    result
  end

  def final_search_result
    job
  end

  def self.skip_check_attributes
    ["major"]
  end
end
