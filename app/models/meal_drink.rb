class MealDrink < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :meal

  belongs_to :drink
  accepts_nested_attributes_for :drink, allow_destroy: true, reject_if: :all_blank
  allow_existing :drink
end
