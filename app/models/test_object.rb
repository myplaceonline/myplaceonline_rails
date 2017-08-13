class TestObject < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :test_object_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :test_object_string, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :test_object_date, type: ApplicationRecord::PROPERTY_TYPE_DATE },
      { name: :test_object_datetime, type: ApplicationRecord::PROPERTY_TYPE_DATETIME },
      { name: :test_object_time, type: ApplicationRecord::PROPERTY_TYPE_TIME },
      { name: :test_object_number, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
      { name: :test_object_decimal, type: ApplicationRecord::PROPERTY_TYPE_DECIMAL },
      { name: :test_object_currency, type: ApplicationRecord::PROPERTY_TYPE_CURRENCY },
      { name: :test_object_boolean, type: ApplicationRecord::PROPERTY_TYPE_BOOLEAN },
      { name: :test_object_enum, type: ApplicationRecord::PROPERTY_TYPE_SELECT },
      { name: :contact, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :test_object_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
      { name: :test_object_instances, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
    ]
  end

  ENUM_A = 0
  ENUM_B = 1

  ENUM = [
    ["myplaceonline.test_objects.test_object_enums.a", ENUM_A],
    ["myplaceonline.test_objects.test_object_enums.b", ENUM_B],
  ]

  validates :test_object_name, presence: true
  
  def display
    test_object_name
  end

  child_files

  child_properties(name: :test_object_instances, sort: "test_object_instance_name ASC")

  child_property(name: :contact)
end
