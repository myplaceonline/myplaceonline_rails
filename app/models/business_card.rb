class BusinessCard < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :contact, presence: true
  
  def display
    contact.display
  end
  
  child_property(name: :contact)

  child_files
end
