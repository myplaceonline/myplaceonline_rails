class Website < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :title, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :url, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :to_visit, type: ApplicationRecord::PROPERTY_TYPE_BOOLEAN },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :website_category, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :website_passwords, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
      { name: :recommender, type: ApplicationRecord::PROPERTY_TYPE_CHILD, model: Contact },
    ]
  end
  
  validates :title, presence: true
  
  child_properties(name: :website_passwords)

  child_property(name: :recommender, model: Contact)

  def display
    title
  end

  def self.skip_check_attributes
    ["to_visit"]
  end
end
