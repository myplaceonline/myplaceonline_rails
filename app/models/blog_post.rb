class BlogPost < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :blog_post_title, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :post, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :blog_post_comments, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
    ]
  end

  belongs_to :blog
  
  validates :blog_post_title, presence: true
  
  child_properties(name: :blog_post_comments, sort: "created_at DESC")

  def display
    blog_post_title
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :blog_post_title,
      :post,
      blog_post_comments_attributes: BlogPostComment.params,
    ]
  end
end
