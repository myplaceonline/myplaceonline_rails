class UpdateBlogPostDates < ActiveRecord::Migration[5.1]
  def change
    BlogPost.all.each do |blog_post|
      MyplaceonlineExecutionContext.do_context(blog_post) do
        blog_post.post_date = blog_post.updated_at
        blog_post.save!
      end
    end
  end
end
