class WebsiteListsController < MyplaceonlineController
  def may_upload
    true
  end
  
  def roll
    set_obj
    initialize_roll
  end
  
  protected
    def insecure
      true
    end

    def sorts
      ["lower(website_lists.website_list_name) ASC"]
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