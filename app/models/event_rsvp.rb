class EventRsvp < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :event
end
