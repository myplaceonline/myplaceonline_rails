class Story < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :story_name, presence: true
  validates :story_time, presence: true
  
  def display
    Myp.appendstrwrap(story_name, Myp.display_datetime_short(story_time, User.current_user))
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    # initialize result here
    result.story_time = Time.now
    result
  end
end
