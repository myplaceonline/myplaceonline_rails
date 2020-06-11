class Boondocking < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :camp_location, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  def display
    self.camp_location.display
  end

  child_property(name: :camp_location, required: true)

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
