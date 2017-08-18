class Diet < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :diet_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :dietary_requirements_collection, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  validates :diet_name, presence: true
  
  def display
    diet_name
  end

  child_property(name: :dietary_requirements_collection)
  
  child_properties(name: :diet_foods, has_many_lambda: lambda { includes(:food).order(["diet_foods.food_type NULLS LAST", "foods.food_name"]) })

  def action_link
    Rails.application.routes.url_helpers.send("diet_consume_path", self)
  end
  
  def action_link_title
    I18n.t("myplaceonline.diets.consume")
  end
  
  def action_link_icon
    "check"
  end

  def self.category_split_button_link
    Rails.application.routes.url_helpers.send("diets_main_path")
  end
  
  def self.category_split_button_title
    I18n.t("myplaceonline.diets.main")
  end

  def self.category_split_button_icon
    "star"
  end
end
