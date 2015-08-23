class Subscription < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  validates :name, presence: true
  
  belongs_to :periodic_payment
  accepts_nested_attributes_for :periodic_payment, reject_if: :all_blank
  allow_existing :periodic_payment
  
  def display
    name
  end
end
