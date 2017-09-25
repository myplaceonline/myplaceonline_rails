class FeedItemsController < MyplaceonlineController
  def path_name
    "feed_feed_item"
  end

  def form_path
    "feed_items/form"
  end

  def nested
    true
  end

  def mark_read
    set_obj
    @obj.is_read = true
    @obj.save!
    render json: { result: true }
  end

  def item_classes(obj)
    "feed_item" + (obj.is_read? ? " bghighlight" : "")
  end

  def data_split_icon
    "action"
  end
  
  def split_link(obj)
    ActionController::Base.helpers.link_to(
      I18n.t("myplaceonline.feeds.item_link"),
      obj.full_feed_link
    )
  end
  
  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.feed_items.feed"),
        link: feed_path(@parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.feed_items.feed"),
        link: feed_path(@obj.feed),
        icon: "back"
      }
    ]
  end
  
  def read_and_redirect
    set_obj
    @obj.is_read = true
    @obj.save!
    redirect_to @obj.full_feed_link
  end
  
  protected
    def insecure
      true
    end

    def sorts
      ["feed_items.publication_date DESC"]
    end

    def obj_params
      params.require(:feed_item).permit(
        :feed_title,
        :feed_link,
        :content,
        :publication_date,
        :guid,
        :is_read
      )
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      Feed
    end
end
