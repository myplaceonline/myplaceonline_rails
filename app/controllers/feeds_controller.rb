class FeedsController < MyplaceonlineController
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
      flash[:notice] = I18n.t("myplaceonline.feeds.new_items", count: new_items)
    else
      flash[:notice] = I18n.t("myplaceonline.feeds.no_new_items")
    end
    redirect_to feed_path(@obj)
  end

  protected
    def sorts
      ["lower(feeds.name) ASC"]
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
