class GroupReference < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :parent_group, class_name: Group

  belongs_to :group
  accepts_nested_attributes_for :group, allow_destroy: true, reject_if: :all_blank
  allow_existing :group
end
