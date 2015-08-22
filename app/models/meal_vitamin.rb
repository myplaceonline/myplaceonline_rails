class MealVitamin < MyplaceonlineActiveRecord
  include AllowExistingConcern

  belongs_to :meal

  belongs_to :vitamin
  accepts_nested_attributes_for :vitamin, allow_destroy: true, reject_if: :all_blank
  allow_existing :vitamin
end
