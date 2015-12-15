class GroupContact < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :group

  belongs_to :contact
  accepts_nested_attributes_for :contact, reject_if: :all_blank
  allow_existing :contact
end
