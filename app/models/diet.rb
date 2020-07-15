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
  
  child_properties(name: :diet_foods, has_many_lambda: lambda { joins(:food).order(Arel.sql("diet_foods.food_type NULLS LAST, lower(foods.food_name) ASC")) })

  def action_link
    if !MyplaceonlineExecutionContext.offline?
      Rails.application.routes.url_helpers.send("diet_consume_path", self)
    else
      nil
    end
  end
  
  def action_link_title
    I18n.t("myplaceonline.diets.consume")
  end
  
  def action_link_icon
    "check"
  end

  def self.category_split_button_link
    Rails.application.routes.url_helpers.send("#{self.table_name}_most_visited_path")
  end
  
  def self.category_split_button_title
    I18n.t("myplaceonline.general.most_visited")
  end

  def self.category_split_button_icon
    "star"
  end
end
