class JobMyreference < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :job

  validates :myreference, presence: true

  belongs_to :myreference
  accepts_nested_attributes_for :myreference, reject_if: proc { |attributes| MyreferencesController.reject_if_blank(attributes) }
  allow_existing :myreference
end
