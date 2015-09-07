class Concert < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  validates :concert_date, presence: true
  validates :concert_title, presence: true

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location
  
  def display
    concert_title + " (" + Myp.display_date_short_year(concert_date, User.current_user) + ")"
  end
end
