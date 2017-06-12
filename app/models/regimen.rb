class Regimen < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  
  DAILY = 0

  TYPES = [
    ["myplaceonline.regimens.types.daily", DAILY],
  ]

  def self.properties
    [
      { name: :regimen_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :regimen_items, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
    ]
  end

  validates :regimen_name, presence: true
  
  def display
    regimen_name
  end

  child_properties(name: :regimen_items, sort: "position ASC")
  
  def evaluated_regimen_type
    case self.regimen_type
    when nil, DAILY
      DAILY
    else
      raise "TODO"
    end
  end
  
  def unfinished_items
    case evaluated_regimen_type
    when DAILY
      regimen_items.where("updated_at < ?", User.current_user.date_now.in_time_zone(User.current_user.timezone))
    else
      raise "TODO"
    end
  end

  def reset
    case evaluated_regimen_type
    when DAILY
      new_updated_at = User.current_user.in_time_zone(User.current_user.date_now - 1.days, end_of_day: true)
    else
      raise "TODO"
    end
    regimen_items.update_all(updated_at: new_updated_at)
  end
end
