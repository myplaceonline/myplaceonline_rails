class BlogsController < MyplaceonlineController
  def may_upload
    true
  end

  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.blogs.display"),
        link: blog_display_path(@obj),
        icon: "eye"
      },
      {
        title: I18n.t("myplaceonline.blogs.add_blog_post"),
        link: new_blog_blog_post_path(@obj),
        icon: "plus"
      },
      {
        title: I18n.t("myplaceonline.blogs.blog_posts"),
        link: blog_blog_posts_path(@obj),
        icon: "bars"
      },
      {
        title: I18n.t("myplaceonline.blogs.rss"),
        link: blog_rss_path(@obj) + ".xml",
        icon: "gear"
      },
    ] + super
  end
  
  def display
    set_obj

    offset = Myp.param_integer(params, MyplaceonlineController::PARAM_OFFSET, default_value: 0)
    perpage = Myp.param_integer(params, MyplaceonlineController::PARAM_PER_PAGE, default_value: default_items_per_page)
    perpage = update_items_per_page(perpage, @obj.blog_posts.count)
    
    @blog_posts = @obj.blog_posts.offset(offset).limit(perpage)
  end
  
  def rss
    set_obj
    
    @title = @description = @obj.display
    @link = blog_display_url(@obj)
    @blog_posts = @obj.blog_posts
  end

  def default_items_per_page
    10
  end
  
  def upload
    set_obj
    file = @obj.identity_file_by_name(params[:uploadname])
    respond_identity_file("inline", file)
  end
  
  def page
    set_obj
    @matched_post = nil
    pagename = params[:pagename].downcase
    Rails.logger.debug{"BlogsController.page pagename: #{pagename}"}
    @obj.blog_posts.each do |post|
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

    def sorts
      ["lower(blogs.blog_name) ASC"]
    end

    def obj_params
      params.require(:blog).permit(
        :blog_name,
        :notes,
        blog_files_attributes: FilesController.multi_param_names,
        main_post_attributes: BlogPost.params,
      )
    end
end
