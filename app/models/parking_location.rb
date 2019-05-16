class ParkingLocation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :location, required: true)
  
  def display
    location.display
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
