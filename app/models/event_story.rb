class EventStory < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :event

  child_property(name: :story)
  
  def display
    story.display
  end
end
