class BlogPost < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :blog_post_title, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :post, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

  belongs_to :blog
  
  validates :blog_post_title, presence: true
  
  def display
    blog_post_title
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :blog_post_title,
      :post,
    ]
  end
end
