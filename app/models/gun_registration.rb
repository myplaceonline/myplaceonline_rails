class GunRegistration < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  belongs_to :gun
  validates :expires, presence: true
  
  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: :all_blank
  allow_existing :location

  def display
    Myp.display_date(expires, User.current_user)
  end
end
