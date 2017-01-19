class AwesomeList < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :location, required: true)
  
  child_properties(name: :awesome_list_items)
  
  def display
    location.display
  end
end
