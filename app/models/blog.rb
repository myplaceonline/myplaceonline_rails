class Blog < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :blog_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :blog_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
      { name: :blog_posts, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
      { name: :main_post, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
    ]
  end

  validates :blog_name, presence: true
  
  def display
    blog_name
  end

  child_files

  child_properties(name: :blog_posts, sort: nil)
  
  child_property(name: :main_post, model: BlogPost)
  
  def sorted_blog_posts
    if self.reverse
      self.get_posts.order("post_date ASC NULLS LAST")
    else
      self.get_posts.order("post_date DESC NULLS LAST")
    end
  end
  
  def get_posts
    if User.current_user.guest?
      self.blog_posts.where("requireslogin = false OR requireslogin IS NULL")
    else
      self.blog_posts
    end
  end

  def identity_file_by_name(name)
    result = nil
    name = name.downcase
    name2 = name.gsub(" ", "_")
    Rails.logger.debug{"Blog.identity_file_by_name searching for: #{name} or #{name2}"}
    files = BlogFile.includes(:identity_file).where(blog_id: self.id)
    files.each do |blog_file|
      checkname = blog_file.identity_file.file_file_name.downcase
      i = checkname.rindex(".")
      if !i.nil?
        checkname = checkname[0..i-1]
      end
      #Rails.logger.debug{"Blog.identity_file_by_name comparing: #{checkname}"}
      if checkname == name || checkname == name2
        result = blog_file.identity_file
      end
    end
    result
  end
  
  def unknown_action_permission_mapping(action)
    if action == :page || action == :rss || action == :display
      Permission::ACTION_READ
    else
      Permission::ACTION_UPDATE
    end
  end
  
  def public_actions
    [:display, :page, :rss]
  end
end
