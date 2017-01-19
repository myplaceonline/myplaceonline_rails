class MealVitamin < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :meal

  child_property(name: :vitamin)
end
