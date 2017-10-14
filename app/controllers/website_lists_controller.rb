class WebsiteListsController < MyplaceonlineController
  def may_upload
    true
  end
  
  def roll
    set_obj
    initialize_roll
  end

  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.website_lists.roll"),
        link: website_list_roll_path(@obj),
        icon: "bars"
      }
    ]
  end
  
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.website_lists.website_list_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(website_lists.website_list_name)"]
    end

    def obj_params
      params.require(:website_list).permit(
        :website_list_name,
        :notes,
        :disable_autoload,
        :iframe_height,
        website_list_items_attributes: [
          :id,
          :_destroy,
          :position,
          website_attributes: WebsitesController.param_names
        ]
      )
    end
    
    def initialize_roll
      @options = @obj.website_list_items.to_a.map{|x| [x.website.display, x.website.url]}
      @selected = @obj.disable_autoload ? nil : @obj.website_list_items[0].website.url
      @frame_height = @obj.iframe_height
      if @frame_height.blank? || @frame_height < 10 || @frame_height > 2000
        @frame_height = 500
      end
    end
    
    def showmyplet
      initialize_roll
      @selected = nil
    end
end
