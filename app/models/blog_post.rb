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

  EDIT_TYPE_DEFAULT = 0
  EDIT_TYPE_TEXT = 1

  ENUM = [
    ["myplaceonline.blog_posts.edit_types.default", EDIT_TYPE_DEFAULT],
    ["myplaceonline.blog_posts.edit_types.text", EDIT_TYPE_TEXT],
  ]

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
      :edit_type,
      :post_date,
      :requireslogin,
      blog_post_comments_attributes: BlogPostComment.params,
    ]
  end

  def ideal_path
    "/blogs/#{self.blog.id}/blog_posts/#{self.id}"
  end
  
  def computed_date
    result = self.post_date
    if result.nil?
      result = self.updated_at
    end
    if result.nil?
      result = self.created_at
    end
    
    if !result.nil? && result.utc == result.utc.midnight
      result = result.to_date
    end
    
    result
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.post_date = User.current_user.time_now
    result
  end
end
