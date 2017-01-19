class IdentityLocation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :parent_identity, class_name: Identity

  child_property(name: :location, required: true)

  def self.skip_check_attributes
    ["secondary"]
  end
end
