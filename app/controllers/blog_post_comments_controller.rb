class BlogPostCommentsController < MyplaceonlineController
  def path_name
    "blog_blog_post_blog_post_comment"
  end

  def form_path
    "blog_post_comments/form"
  end

  def nested
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.blog_post_comments.back"),
        link: blog_blog_post_path(@parent.blog, @parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.blog_post_comments.back"),
        link: blog_blog_post_path(@obj.blog_post, @obj.blog_post.blog),
        icon: "back"
      }
    ] + super
  end
  
  def show_path(obj)
    send("#{path_name}_path", obj.blog_post.blog, obj.blog_post, obj)
  end

  def obj_path(obj = @obj)
    send(path_name + "_path", obj.blog_post.blog, obj.blog_post, obj)
  end
  
  def edit_obj_path(obj = @obj)
    send("edit_" + path_name + "_path", obj.blog_post.blog, obj.blog_post, obj)
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_datetime_short_year(obj.created_at, User.current_user)
  end

  protected
    def insecure
      true
    end

    def sorts
      ["blog_post_comments.created_at DESC"]
    end

    def obj_params
      params.require(:blog_post_comment).permit(BlogPostComment.params)
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      [Blog, BlogPost]
    end
end
