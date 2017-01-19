class MedicineUsage < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :usage_time, presence: true
  
  child_properties(name: :medicine_usage_medicines)
  
  def display
    Myp.display_datetime_short(usage_time, User.current_user)
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.usage_time = DateTime.now
    result
  end
end
