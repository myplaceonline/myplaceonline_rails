class JobAccomplishment < ActiveRecord::Base
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
end
