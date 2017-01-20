class MediaDumpFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :media_dump
  
  child_property(name: :identity_file, required: true)
end
