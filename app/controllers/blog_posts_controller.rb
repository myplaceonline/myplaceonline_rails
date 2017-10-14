class BlogPostsController < MyplaceonlineController
  def path_name
    "blog_blog_post"
  end

  def form_path
    "blog_posts/form"
  end

  def nested
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.blog_posts.back"),
        link: blog_path(@parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.blog_posts.back"),
        link: blog_path(@obj.blog),
        icon: "back"
      },
      {
        title: I18n.t("myplaceonline.blog_posts.add_comment"),
        link: new_blog_blog_post_blog_post_comment_path(@obj.blog, @obj),
        icon: "plus"
      },
      {
        title: I18n.t("myplaceonline.blog_posts.comments"),
        link: blog_blog_post_blog_post_comments_path(@obj.blog, @obj),
        icon: "bars"
      },
    ] + super
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_datetime_short_year(obj.post_date, User.current_user)
  end

  def show_wrap
    false
  end
  
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.blog_posts.post_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["blog_posts.post_date"]
    end

    def default_sort_direction
      "desc"
    end

    def obj_params
      params.require(:blog_post).permit(BlogPost.params)
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      Blog
    end
end
