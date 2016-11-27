class FeedsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:load_all, :random, :all_items]
  
  def index
    @message = Feed.status_message
    super
  end
  
  def all_items
    @items = FeedItem.includes(:feed).where("identity_id = #{User.current_user.primary_identity_id} and read is null").order("publication_date DESC")
    render :all_items
  end

  def self.param_names
    [
      :id,
      :_destroy,
      :name,
      :url
    ]
  end

  def self.reject_if_blank(attributes)
    attributes.dup.all?{|key, value|
      value.blank?
    }
  end
  
  def load
    set_obj
    new_items = @obj.load_feed
    if new_items > 0
      message = I18n.t("myplaceonline.feeds.new_items", count: new_items)
    else
      message = I18n.t("myplaceonline.feeds.no_new_items")
    end
    redirect_to(
      obj_path,
      :flash => { :notice => message }
    )
  end
  
  def load_all
    Feed.load_all(all(strict: true).count)
    redirect_to index_path,
          :flash => { :notice => I18n.t("myplaceonline.feeds.loading_all") }
  end

  def random
    x = all.to_a.delete_if{|x| x.number_unread == 0}
    redirect_to feed_path(x[SecureRandom.random_number(x.length)])
  end

  def mark_all_read
    set_obj
    @obj.mark_all_read
    redirect_to feed_path(
      @obj,
      :flash => { :notice => I18n.t("myplaceonline.feeds.all_marked_read") }
    )
  end
  
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    obj.number_unread.to_s
  end
    
  def data_split_icon
    "refresh"
  end
  
  def split_link(obj)
    ActionController::Base.helpers.link_to(
      I18n.t("myplaceonline.feeds.load"),
      feed_load_path(obj)
    )
  end
  
  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.feeds.load_all"),
        link: feeds_load_all_path,
        icon: "refresh"
      },
      {
        title: I18n.t("myplaceonline.feeds.random_feed"),
        link: feeds_random_path,
        icon: "gear"
      },
      {
        title: I18n.t("myplaceonline.feeds.all_items"),
        link: feeds_all_items_path,
        icon: "bars"
      }
    ]
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.feeds.random_feed"),
        link: feeds_random_path,
        icon: "gear"
      },
      {
        title: I18n.t("myplaceonline.feeds.mark_all_read"),
        link: feed_mark_all_read_path(@obj),
        icon: "check"
      },
      {
        title: I18n.t("myplaceonline.feeds.feed_items"),
        link: feed_feed_items_path(@obj),
        icon: "bars"
      },
      {
        title: I18n.t("myplaceonline.feeds.load"),
        link: feed_load_path(@obj),
        icon: "refresh"
      }
    ] + super
  end
  
  protected
    def sorts
      sorts_helper {["lower(feeds.name) #{@selected_sort_direction}"]}
    end

    def obj_params
      params.require(:feed).permit(
        FeedsController.param_names
      )
    end

    def insecure
      true
    end

    def favorite_items_sort
      [model.table_name + ".unread_items ASC", model.table_name + ".visit_count DESC"]
    end
    
    def favorite_items(strict: false)
      super(strict: strict).where("unread_items > 0")
    end
end
