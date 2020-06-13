class WirelessNetwork < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :network_names, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :password, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :location, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  validates :network_names, presence: true
  
  def display
    network_names
  end

  child_property(name: :location)
  child_property(name: :password)

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
