class BlogsController < MyplaceonlineController
  def may_upload
    true
  end

  def footer_items_show
    if @matched_post.nil?
      result = []

      result << {
        title: I18n.t("myplaceonline.blogs.display"),
        link: blog_display_path(@obj),
        icon: "eye"
      }
      
      if !MyplaceonlineExecutionContext.offline?
        result << {
          title: I18n.t("myplaceonline.blogs.add_blog_post"),
          link: new_blog_blog_post_path(@obj),
          icon: "plus"
        }
      end
      
      result << {
        title: I18n.t("myplaceonline.blogs.blog_posts"),
        link: blog_blog_posts_path(@obj),
        icon: "bars"
      }
      
      result << {
        title: I18n.t("myplaceonline.blogs.rss"),
        link: blog_rss_path(@obj) + ".xml",
        icon: "gear"
      }
      
      result + super
    else
      nil
    end
  end
  
  def display
    set_obj

    offset = Myp.param_integer(params, MyplaceonlineController::PARAM_OFFSET, default_value: 0)
    perpage = Myp.param_integer(params, MyplaceonlineController::PARAM_PER_PAGE, default_value: default_items_per_page)
    perpage = update_items_per_page(perpage, @obj.sorted_blog_posts.count)
    
    @blog_posts = @obj.sorted_blog_posts.offset(offset).limit(perpage)
  end
  
  def rss
    set_obj
    
    @title = @description = @obj.display
    @link = blog_display_url(@obj)
    @blog_posts = @obj.sorted_blog_posts
    
    render(action: :rss, content_type: "application/rss+xml", :formats => [:xml])
  end

  def default_items_per_page
    !@obj.nil? && !@obj.posts_per_page.nil? ? @obj.posts_per_page : 5
  end
  
  def upload
    set_obj
    file = @obj.identity_file_by_name(params[:uploadname])
    if !file.nil?
      respond_identity_file("inline", file)
    else
      head 404
    end
  end
  
  def upload_thumbnail
    set_obj
    file = @obj.identity_file_by_name(params[:uploadname])
    if !file.nil?
      respond_identity_file("inline", file, thumbnail: true)
    else
      head 404
    end
  end
  
  def page
    set_obj
    @matched_post = nil
    pagename = params[:pagename].downcase.gsub("%20", " ")
    Rails.logger.debug{"BlogsController.page pagename: #{pagename}"}
    @obj.sorted_blog_posts.each do |post|
      checkpagename = post.blog_post_title.downcase
      Rails.logger.debug{"BlogsController.page checkpagename: #{checkpagename}"}
      if checkpagename == pagename
        @matched_post = post
      end
    end
    if @matched_post.nil?
      redirect_to blog_path(@obj)
    else
      @obj = @matched_post
      render(template: "myplaceonline/show")
      #redirect_to blog_blog_post_path(@obj, @matched_post)
    end
  end
  
  def show_wrap
    if @matched_post.nil?
      super
    else
      false
    end
  end
  
  def paths_form_name
    if @matched_post.nil?
      super
    else
      "blog_posts"
    end
  end
  
  def heading_prefix_category
    false
  end
  
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.blogs.blog_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(blogs.blog_name)"]
    end

    def obj_params
      params.require(:blog).permit(
        :blog_name,
        :notes,
        :reverse,
        :posts_per_page,
        blog_files_attributes: FilesController.multi_param_names,
        main_post_attributes: BlogPost.params,
      )
    end

    def publicly_shareable_actions
      [:show, :page, :rss, :display]
    end
end
