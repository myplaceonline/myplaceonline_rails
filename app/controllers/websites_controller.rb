class WebsitesController < MyplaceonlineController
  def self.param_names
    [
      :title,
      :url
    ]
  end
  
  protected
    def insecure
      true
    end

    def sorts
      ["lower(websites.title) ASC"]
    end

    def obj_params
      params.require(:website).permit(
        WebsitesController.param_names
      )
    end
end
