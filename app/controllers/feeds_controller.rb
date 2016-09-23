class FeedsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:load_all]
  
  def index
    status = FeedLoadStatus.where(identity_id: current_user.primary_identity_id).first
    if !status.nil?
      if status.finished?
        @message = I18n.t("myplaceonline.feeds.loading_all_finished", complete: status.items_complete, errors: status.items_error)
        status.destroy!
      else
        @message = I18n.t("myplaceonline.feeds.loading_all_inprogress", complete: status.items_progressed, total: status.items_total, percent: ((status.items_progressed.to_f / status.items_total.to_f) * 100.0).round(2))
      end
    end
    super
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
    redirect_to feed_path(@obj,
          :flash => { :notice => message })
  end
  
  def load_all
    status = FeedLoadStatus.where(identity_id: current_user.primary_identity_id).first
    if status.nil?
      FeedLoadStatus.create(
        identity_id: current_user.primary_identity_id,
        items_complete: 0,
        items_total: all(strict: true).count,
        items_error: 0
      )
      LoadRssFeedsJob.perform_later(current_user)
    end
    redirect_to feeds_path,
          :flash => { :notice => I18n.t("myplaceonline.feeds.loading_all") }
  end

  def mark_all_read
    set_obj
    FeedItem.where(
      identity_id: current_user.primary_identity_id,
      feed_id: @obj.id
    ).update_all(
      read: Time.now
    )
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
end
