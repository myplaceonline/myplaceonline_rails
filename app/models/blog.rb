class Blog < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :blog_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :blog_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
      { name: :blog_posts, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
    ]
  end

  validates :blog_name, presence: true
  
  def display
    blog_name
  end

  child_files

  child_properties(name: :blog_posts, sort: "updated_at DESC")
end