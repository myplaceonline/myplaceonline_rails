class Headache < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :started, presence: true
  
  def display
    result = Myp.display_datetime_short(started, User.current_user)
    if !headache_location.blank?
      result += " (" + headache_location + ")"
    end
    result
  end
end
