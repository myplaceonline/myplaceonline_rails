class EventRsvp < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :event
end
