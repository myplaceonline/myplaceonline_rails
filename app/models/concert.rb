class Concert < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :concert_date, presence: true
  validates :concert_title, presence: true

  child_property(name: :location)
  
  child_properties(name: :concert_musical_groups)

  def display
    concert_title + " (" + Myp.display_date_short_year(concert_date, User.current_user) + ")"
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.concert_date = Date.today
    result
  end

  child_pictures
end
