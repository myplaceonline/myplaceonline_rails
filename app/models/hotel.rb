class Hotel < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :location, presence: true

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location
  
  def display
    result = location.display_really_simple
    #result = Myp.appendstr(result, room_number.to_s, nil, " (" + I18n.t("myplaceonline.hotels.room_number") + " ", ")")
    result
  end
end
