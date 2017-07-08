class Category < ApplicationRecord
  include MyplaceonlineActiveRecordBaseConcern

  belongs_to :parent, class_name: "Category"
  has_many :category_points_amounts
  
  def human_title
    Category.human_title(name)
  end
  
  def human_title_singular
    Category.human_title_singular(name)
  end
  
  def filtertext
    Category.filtertext(name, additional_filtertext)
  end
  
  def self.human_title(name)
    I18n.t("myplaceonline.category." + name.downcase)
  end
  
  def self.human_title_singular(name)
    I18n.t("myplaceonline.category." + name.downcase).singularize
  end
  
  def self.filtertext(name, additional_filtertext)
    result = self.human_title(name)
    if !additional_filtertext.nil?
      result += " " + additional_filtertext
    end
    result
  end
  
  # This can be nil for things like simple categories (e.g. health)
  def model
    Object.const_get(Myp.category_to_model_name(self.name))
  end

  def category_split_button_link
    m = self.model
    m.nil? ? nil : m.category_split_button_link
  end

  def category_split_button_title
    m = self.model
    m.nil? ? nil : m.category_split_button_title
  end

  def category_split_button_icon
    m = self.model
    m.nil? ? nil : m.category_split_button_icon
  end
end
