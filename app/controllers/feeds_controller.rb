class FeedsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:load_all, :random, :all_items]
  
  def index
    @message = Feed.status_message
    super
  end
  
  def all_items
    @items = FeedItem.includes(:feed).where("identity_id = #{User.current_user.current_identity_id} and read is null").order("publication_date DESC")
    render :all_items
  end

  def self.param_names
    [
      :id,
      :_destroy,
      :name,
      :url,
      :new_notify
    ]
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
  
  def mark_page_read
    set_obj

    offset = Myp.param_integer(params, MyplaceonlineController::PARAM_OFFSET, default_value: 0)
    perpage = Myp.param_integer(params, MyplaceonlineController::PARAM_PER_PAGE, default_value: MyplaceonlineController::DEFAULT_PER_PAGE)

    count = 0
    
    ApplicationRecord.transaction do
      items = @obj.unread_feed_items.offset(offset).limit(perpage)
      count = items.count
      FeedItem.where("id in (?)", items.map{|x| x.id}).update_all(
        read: Time.now
      )
      @obj.update_column(:unread_items, @obj.unread_items - count)
    end
    
    redirect_to(
      feed_path(
        @obj,
        MyplaceonlineController::PARAM_OFFSET => params[MyplaceonlineController::PARAM_OFFSET],
        MyplaceonlineController::PARAM_PER_PAGE => params[MyplaceonlineController::PARAM_PER_PAGE]
      ),
      flash: { notice: I18n.t("myplaceonline.feeds.page_marked_read", count: count) }
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
    result = super

    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.feeds.load_all"),
        link: feeds_load_all_path,
        icon: "refresh"
      }
      
      result << {
        title: I18n.t("myplaceonline.feeds.random_feed"),
        link: feeds_random_path,
        icon: "gear"
      }
    end
    
    result << {
      title: I18n.t("myplaceonline.feeds.all_items"),
      link: feeds_all_items_path,
      icon: "bars"
    }

    result
  end
  
  def footer_items_show
    result = []
    
    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.feeds.random_feed"),
        link: feeds_random_path,
        icon: "gear"
      }
      
      result << {
        title: I18n.t("myplaceonline.feeds.load"),
        link: feed_load_path(@obj),
        icon: "refresh"
      }
      
      result << {
        title: I18n.t("myplaceonline.feeds.mark_page_read"),
        link:
          feed_mark_page_read_path(
            @obj,
            MyplaceonlineController::PARAM_OFFSET => params[MyplaceonlineController::PARAM_OFFSET],
            MyplaceonlineController::PARAM_PER_PAGE => params[MyplaceonlineController::PARAM_PER_PAGE]
          ),
        icon: "check"
      }
      
      result << {
        title: I18n.t("myplaceonline.feeds.mark_all_read"),
        link: feed_mark_all_read_path(@obj),
        icon: "check"
      }
    end
    
    result << {
      title: I18n.t("myplaceonline.feeds.feed_items"),
      link: feed_feed_items_path(@obj),
      icon: "bars"
    }
    
    result + super
  end
  
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.feeds.name"), default_sort_columns[0]],
        [I18n.t("myplaceonline.feeds.unread_count"), "feeds.unread_items"],
      ]
    end

    def default_sort_columns
      ["lower(feeds.name)"]
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
    
    def object_to_destroy(obj)
      podcast = Podcast.where(feed: obj).take
      if !podcast.nil?
        podcast
      else
        web_comic = WebComic.where(feed: obj).take
        if !web_comic.nil?
          web_comic
        else
          obj
        end
      end
    end
end
