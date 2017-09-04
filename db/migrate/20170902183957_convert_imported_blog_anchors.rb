class ConvertImportedBlogAnchors < ActiveRecord::Migration[5.1]
  def change
    BlogPost.all.each do |blog_post|
      MyplaceonlineExecutionContext.do_context(blog_post) do
        i = 0
        found = false
        while true do
          match_data = blog_post.post.match(/<a name="([^"]+)"/, i)
          if !match_data.nil?
            found = true
            match_offset = match_data.offset(0)[0]
            replacement = "<a name=\"" + match_data[1].strip + "\""
            blog_post.post = match_data.pre_match + replacement + match_data.post_match
            i = match_offset + replacement.length
          else
            break
          end
        end
        if found
          blog_post.save!
        end
      end
    end
  end
end
