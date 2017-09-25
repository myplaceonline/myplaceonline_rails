class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  PROPERTY_TYPE_STRING = 0
  PROPERTY_TYPE_MARKDOWN = 1
  PROPERTY_TYPE_DATE = 2
  PROPERTY_TYPE_DATETIME = 3
  PROPERTY_TYPE_TIME = 4
  PROPERTY_TYPE_NUMBER = 5
  PROPERTY_TYPE_DECIMAL = 6
  PROPERTY_TYPE_CURRENCY = 7
  PROPERTY_TYPE_CHILD = 8
  PROPERTY_TYPE_CHILDREN = 9
  PROPERTY_TYPE_FILES = 10
  PROPERTY_TYPE_HIDDEN = 11
  PROPERTY_TYPE_BOOLEAN = 12
  PROPERTY_TYPE_FILE = 13
  PROPERTY_TYPE_SELECT = 14
  PROPERTY_TYPE_TEXT = 15

  def self.properties
    raise "self.properties not implemented in #{self.name}"
  end

  def self.permitted_parameters
    self.properties.map do |property|
      case property[:type]
      when ApplicationRecord::PROPERTY_TYPE_CHILD, ApplicationRecord::PROPERTY_TYPE_CHILDREN, ApplicationRecord::PROPERTY_TYPE_FILES
        model = property[:model].blank? ? Object.const_get(property[:name].to_s.singularize.camelize) : property[:model]
        { "#{property[:name]}_attributes" => [:id, :_destroy] + model.permitted_parameters }
      else
        property[:name]
      end
    end
  end

  protected
    def default_url_options
      Rails.configuration.default_url_options
    end
end
