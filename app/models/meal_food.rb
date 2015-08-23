class MealFood < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  belongs_to :meal

  belongs_to :food
  accepts_nested_attributes_for :food, allow_destroy: true, reject_if: :all_blank
  allow_existing :food
end
