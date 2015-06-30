class WebsitesController < MyplaceonlineController
  def model
    Website
  end

  protected
    def sorts
      ["lower(websites.title) ASC"]
    end

    def obj_params
      params.require(:website).permit(:title, :url)
    end
end
