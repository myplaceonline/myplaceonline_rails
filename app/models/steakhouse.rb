class Steakhouse < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :location, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  validates :location, presence: true
  
  def display
    location.display
  end

  child_property(name: :location)

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
