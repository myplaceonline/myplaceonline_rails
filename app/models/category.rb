class Category < ApplicationRecord
  include MyplaceonlineActiveRecordBaseConcern

  belongs_to :parent, class_name: "Category"
  has_many :category_points_amounts
  
  def display
    human_title_singular
  end
  
  def human_title
    if @cached_human_title.nil?
      @cached_human_title = {}
    end
    result = @cached_human_title[I18n.locale]
    if result.nil?
      result = Category.human_title(name, link)
      @cached_human_title[I18n.locale] = result
    end
    result
  end
  
  def human_title_singular
    if @cached_human_title_singular.nil?
      @cached_human_title_singular = {}
    end
    result = @cached_human_title_singular[I18n.locale]
    if result.nil?
      result = Category.human_title_singular(name, link)
      @cached_human_title_singular[I18n.locale] = result
    end
    result
  end
  
  def filtertext
    Category.filtertext(name, link, additional_filtertext)
  end
  
  def self.human_title(name, link)
    if !Category.is_engine_model?(link)
      I18n.t("myplaceonline.category." + name.downcase)
    else
      engine = link.split("/")[0]
      engine_model = link.split("/")[1]
      I18n.t(engine + ".category." + engine_model)
    end
  end
  
  def self.human_title_singular(name, link)
    self.human_title(name, link).singularize
  end
  
  def self.filtertext(name, link, additional_filtertext)
    result = self.human_title(name, link)
    if !additional_filtertext.nil?
      result += " " + additional_filtertext
    end
    result
  end
  
  def is_engine_model?
    return Category.is_engine_model?(self.link)
  end
  
  def self.is_engine_model?(link)
    return !link.nil? && link.include?("/")
  end
  
  # This can be nil for things like simple categories (e.g. health)
  def model
    if !self.is_engine_model?
      Object.const_get(Myp.category_to_model_name(self.name))
    else
      engine = self.link.split("/")[0]
      engine_model = self.link.split("/")[1]
      Object.const_get(engine.camelcase + "::" + engine_model.camelize.singularize)
    end
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
