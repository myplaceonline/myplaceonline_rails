class PerishableFood < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :food, presence: true
  
  belongs_to :food
  accepts_nested_attributes_for :food, allow_destroy: true, reject_if: :all_blank
  allow_existing :food
  
  def display
    food.display
  end
end
