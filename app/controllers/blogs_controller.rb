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
    ] + super
  end
  
  def display
    set_obj

    offset = Myp.param_integer(params, MyplaceonlineController::PARAM_OFFSET, default_value: 0)
    perpage = Myp.param_integer(params, MyplaceonlineController::PARAM_PER_PAGE, default_value: default_items_per_page)
    perpage = update_items_per_page(perpage, @obj.blog_posts.count)
    
    @blog_posts = @obj.blog_posts.offset(offset).limit(perpage)
  end

  def default_items_per_page
    10
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
      )
    end
end
