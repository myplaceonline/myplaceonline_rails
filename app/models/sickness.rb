class Sickness < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :sickness_start, type: ApplicationRecord::PROPERTY_TYPE_DATE },
      { name: :sickness_end, type: ApplicationRecord::PROPERTY_TYPE_DATE },
      { name: :coughing, type: ApplicationRecord::PROPERTY_TYPE_BOOLEAN },
      { name: :sneezing, type: ApplicationRecord::PROPERTY_TYPE_BOOLEAN },
      { name: :throwing_up, type: ApplicationRecord::PROPERTY_TYPE_BOOLEAN },
      { name: :fever, type: ApplicationRecord::PROPERTY_TYPE_BOOLEAN },
      { name: :runny_nose, type: ApplicationRecord::PROPERTY_TYPE_BOOLEAN },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :test_object_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :sickness_start, presence: true
  
  def display
    Myp.display_date_month_year_simple(self.sickness_start, User.current_user)
  end

  child_files

  def self.build(params = nil)
    result = self.dobuild(params)
    result.sickness_start = Date.today
    result
  end
end
