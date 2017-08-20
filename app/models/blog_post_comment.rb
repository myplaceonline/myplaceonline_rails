class BlogPostComment < ApplicationRecord
  belongs_to :blog_post
  belongs_to :commenter_identity
  belongs_to :identity
end
