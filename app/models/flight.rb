class Flight < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :flight_name, presence: true
  
  has_many :flight_legs, -> { order('position ASC') }, :dependent => :destroy
  accepts_nested_attributes_for :flight_legs, allow_destroy: true, reject_if: :all_blank

  def display
    Myp.appendstrwrap(flight_name, Myp.display_date_short_year(flight_start_date, User.current_user))
  end
end