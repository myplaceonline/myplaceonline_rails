class Podcast < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :feed, required: true)
  
  def display
    feed.display
  end
end
