class Beach < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :location, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :crowded, type: ApplicationRecord::PROPERTY_TYPE_BOOLEAN },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :free, type: ApplicationRecord::PROPERTY_TYPE_BOOLEAN },
    ]
  end
  
  def display
    location.display
  end

  child_property(name: :location, required: true)

  def self.skip_check_attributes
    ["crowded","fires_allowed","fires_disallowed","free","paid","tents_allowed","tents_disallowed","canopies_allowed","canopies_disallowed","dogs_allowed"]
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
