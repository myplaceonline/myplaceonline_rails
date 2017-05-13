class CampLocation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :location, required: true)
  
  child_property(name: :membership)
  
  def display
    location.display
  end

  def self.skip_check_attributes
    ["overnight_allowed", "free", "bathroom", "vehicle_parking", "fresh_water", "electricity", "sewage", "shower", "internet", "trash", "boondocking", "cell_phone_reception", "cell_phone_data", "birds_chirping", "near_busy_road", "chance_high_wind"]
  end
end
