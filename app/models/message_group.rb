class MessageGroup < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :email

  belongs_to :group
  accepts_nested_attributes_for :group, reject_if: proc { |attributes| GroupsController.reject_if_blank(attributes) }
  allow_existing :group
end
