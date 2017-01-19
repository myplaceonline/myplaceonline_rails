class TripStory < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :trip

  child_property(name: :story)
  
  def display
    story.display
  end
end
