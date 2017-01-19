class WebComic < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :website, required: true)
  
  child_property(name: :feed)
  
  def display
    web_comic_name
  end
end
