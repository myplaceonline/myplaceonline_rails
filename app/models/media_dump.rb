class MediaDump < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :media_dump_name, presence: true

  child_files
  
  def display
    media_dump_name
  end
end
