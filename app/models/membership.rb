class Membership < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  validates :name, presence: true
  
  belongs_to :periodic_payment
  accepts_nested_attributes_for :periodic_payment, reject_if: proc { |attributes| PeriodicPaymentsController.reject_if_blank(attributes) }
  allow_existing :periodic_payment
  
  def display
    name
  end
end
