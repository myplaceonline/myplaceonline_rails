class GroupContact < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :group

  child_property(name: :contact)
end
