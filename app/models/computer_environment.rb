class ComputerEnvironment < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :computer_environment_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :computer_environment_type, type: ApplicationRecord::PROPERTY_TYPE_SELECT },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :computer_environment_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  COMPUTER_ENVIRONMENT_TYPE_TEST = 0
  COMPUTER_ENVIRONMENT_TYPE_PRODUCTION = 1
  COMPUTER_ENVIRONMENT_TYPE_QA = 2
  COMPUTER_ENVIRONMENT_TYPE_PERFORMANCE_TEST = 3
  COMPUTER_ENVIRONMENT_TYPE_STAGING = 4

  COMPUTER_ENVIRONMENT_TYPES = [
    ["myplaceonline.computer_environments.computer_environment_types.test", COMPUTER_ENVIRONMENT_TYPE_TEST],
    ["myplaceonline.computer_environments.computer_environment_types.production", COMPUTER_ENVIRONMENT_TYPE_PRODUCTION],
    ["myplaceonline.computer_environments.computer_environment_types.qa", COMPUTER_ENVIRONMENT_TYPE_QA],
    ["myplaceonline.computer_environments.computer_environment_types.performance_test", COMPUTER_ENVIRONMENT_TYPE_PERFORMANCE_TEST],
    ["myplaceonline.computer_environments.computer_environment_types.staging", COMPUTER_ENVIRONMENT_TYPE_STAGING],
  ]

  validates :computer_environment_name, presence: true
  
  def display
    computer_environment_name
  end

  child_files

  child_properties(name: :computer_environment_addresses, sort: "host_name ASC")

  child_properties(name: :computer_environment_passwords)
end
