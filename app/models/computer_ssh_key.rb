class ComputerSshKey < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :computer

  child_property(name: :ssh_key)
end
