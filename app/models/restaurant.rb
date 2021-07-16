class Restaurant < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :location, presence: true

  child_property(name: :location)
  
  def display
    location.display
  end

  child_pictures

  def self.skip_check_attributes
    ["visited", "rooftop"]
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
  
  child_properties(name: :restaurant_dishes, sort: "dish_name ASC")
end
