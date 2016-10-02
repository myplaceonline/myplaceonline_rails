class PodcastsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:load_all]
  
  def index
    @message = Feed.status_message
    super
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    obj.feed.number_unread.to_s
  end
    
  def data_split_icon
    "refresh"
  end
  
  def split_link(obj)
    ActionController::Base.helpers.link_to(
      I18n.t("myplaceonline.feeds.load"),
      podcast_load_path(obj)
    )
  end
  
  def footer_items_index
    super + [
      {
        title: I18n.t('myplaceonline.feeds.load_all'),
        link: podcasts_load_all_path,
        icon: "refresh"
      }
    ]
  end
  
  def footer_items_show
    super + [
      {
        title: I18n.t('myplaceonline.feeds.feed_items'),
        link: feed_feed_items_path(@obj.feed),
        icon: "bars"
      },
      {
        title: I18n.t('myplaceonline.feeds.load'),
        link: podcast_load_path(@obj),
        icon: "refresh"
      },
      {
        title: I18n.t('myplaceonline.feeds.mark_all_read'),
        link: podcast_mark_all_read_path(@obj),
        icon: "check"
      }
    ]
  end

  def load
    set_obj
    new_items = @obj.feed.load_feed
    if new_items > 0
      message = I18n.t("myplaceonline.feeds.new_items", count: new_items)
    else
      message = I18n.t("myplaceonline.feeds.no_new_items")
    end
    redirect_to obj_path(@obj,
          :flash => { :notice => message })
  end
  
  def load_all
    Feed.load_all(all(strict: true).count)
    redirect_to index_path,
          :flash => { :notice => I18n.t("myplaceonline.feeds.loading_all") }
  end

  def mark_all_read
    set_obj
    @obj.feed.mark_all_read
    redirect_to podcast_path(
      @obj,
      :flash => { :notice => I18n.t("myplaceonline.feeds.all_marked_read") }
    )
  end

  protected
    def sorts
      ["podcasts.updated_at DESC"]
    end

    def obj_params
      params.require(:podcast).permit(
        feed_attributes: FeedsController.param_names
      )
    end
end
