class JobMyreference < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :job

  validates :myreference, presence: true

  child_property(name: :myreference)
  
  def display
    myreference.display
  end

  def self.skip_check_attributes
    ["can_contact"]
  end
end
