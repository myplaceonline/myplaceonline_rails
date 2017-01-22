class Check < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :description, presence: true
  
  def display
    description
  end

  child_files

  child_property(name: :contact)
  child_property(name: :company)
  child_property(name: :bank_account)
end
