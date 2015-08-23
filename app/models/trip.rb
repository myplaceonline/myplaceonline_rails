class Trip < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  validates :location, presence: true
  validates :started, presence: true

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location
  
  has_many :trip_pictures, :dependent => :destroy
  accepts_nested_attributes_for :trip_pictures, allow_destroy: true, reject_if: :all_blank
  
  def display
    result = Myp.display_date_short_year(started, User.current_user)
    if !ended.nil?
      result += " - " + Myp.display_date_short_year(ended, User.current_user)
    end
    result += " (" + location.display_simple + ")"
    if work
      result += " (" + I18n.t("myplaceonline.trips.work") + ")"
    end
    result
  end
end
