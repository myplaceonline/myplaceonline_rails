class Concert < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  validates :concert_date, presence: true
  validates :concert_title, presence: true

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location
  
  has_many :concert_musical_groups, :dependent => :destroy
  accepts_nested_attributes_for :concert_musical_groups, allow_destroy: true, reject_if: :all_blank

  def display
    concert_title + " (" + Myp.display_date_short_year(concert_date, User.current_user) + ")"
  end

  def self.build(params = nil)
    result = super(params)
    result.concert_date = Date.today
    result
  end
end
