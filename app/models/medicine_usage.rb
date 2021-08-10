class MedicineUsage < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :usage_time, presence: true
  
  child_properties(name: :medicine_usage_medicines)
  
  def display
    result = Myp.display_datetime_short_year(usage_time, User.current_user)
    if !self.usage_end.nil?
        result += " - " + Myp.display_datetime_short_year(self.usage_end, User.current_user)
    end
    result = Myp.appendstrwrap(result, self.description)
    return result
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.usage_time = DateTime.now
    result
  end
end
