class ComputerSshKey < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :computer

  belongs_to :ssh_key
  accepts_nested_attributes_for :ssh_key, allow_destroy: true, reject_if: :all_blank
  allow_existing :ssh_key
end
