class IdentityLocation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :secondary, type: ApplicationRecord::PROPERTY_TYPE_BOOLEAN },
      { name: :location, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end
  
  belongs_to :parent_identity, class_name: Identity

  child_property(name: :location, required: true)

  def self.skip_check_attributes
    ["secondary"]
  end
end
