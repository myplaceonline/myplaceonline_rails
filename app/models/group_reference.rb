class GroupReference < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :parent_group, class_name: Group

  child_property(name: :group)
end
