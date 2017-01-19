class Therapist < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def display
    result = ""
    if !contact.nil?
      result = contact.display
    end
    result
  end
  
  child_property(name: :contact, required: true)
end
