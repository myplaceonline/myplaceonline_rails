class Meal < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :meal_time, presence: true
  
  child_property(name: :location)
  
  child_properties(name: :meal_foods)

  child_properties(name: :meal_drinks)

  child_properties(name: :meal_vitamins)

  def display
    Myp.display_datetime_short(meal_time, User.current_user)
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.meal_time = DateTime.now
    result
  end
end
