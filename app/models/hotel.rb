class Hotel < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :location, required: true)
  
  def display
    result = location.display_really_simple
    #result = Myp.appendstr(result, room_number.to_s, nil, " (" + I18n.t("myplaceonline.hotels.room_number") + " ", ")")
    result
  end

  def self.category_split_button_link
    Rails.application.routes.url_helpers.send("#{self.table_name}_map_path")
  end
  
  def self.category_split_button_title
    I18n.t("myplaceonline.general.map")
  end

  def self.category_split_button_icon
    "navigation"
  end
end
