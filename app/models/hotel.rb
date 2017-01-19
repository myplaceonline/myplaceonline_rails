class Hotel < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :location, required: true)
  
  def display
    result = location.display_really_simple
    #result = Myp.appendstr(result, room_number.to_s, nil, " (" + I18n.t("myplaceonline.hotels.room_number") + " ", ")")
    result
  end
end
