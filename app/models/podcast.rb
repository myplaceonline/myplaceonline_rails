class Podcast < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :feed, required: true, destroy_dependent: true)
  
  def display
    feed.display
  end
end
