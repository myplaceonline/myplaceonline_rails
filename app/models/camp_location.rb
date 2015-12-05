class CampLocation < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  validates :location, presence: true

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location
  
  belongs_to :membership
  accepts_nested_attributes_for :membership, reject_if: proc { |attributes| MembershipsController.reject_if_blank(attributes) }
  allow_existing :membership
  
  def display
    location.display
  end
end
