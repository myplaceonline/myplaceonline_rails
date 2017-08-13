class BlogsController < MyplaceonlineController
  def may_upload
    true
  end

  def footer_items_show
    [
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
