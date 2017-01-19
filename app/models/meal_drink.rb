class MealDrink < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :meal

  child_property(name: :drink)
end
