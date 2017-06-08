class WebsiteScrapersController < MyplaceonlineController
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.website_scrapers.scrape"),
        link: website_scraper_scrape_path(@obj),
        icon: "action"
      }
    ] + super
  end
  
  def scrape
    set_obj
    
    begin
      results = Myp.http_get(url: @obj.website_url)
      @raw_response = CGI::escapeHTML(results[:body])
      @raw_response = @raw_response.gsub(/\n/, "\n<br />")
    rescue => e
      flash[:error] = t("myplaceonline.website_scrapers.scrape_error", message: e.to_s)
    end
  end
  
  protected
    def insecure
      true
    end

    def sorts
      ["lower(website_scrapers.scraper_name) ASC"]
    end

    def obj_params
      params.require(:website_scraper).permit(
        :scraper_name,
        :website_url,
        :notes
      )
    end

    def required_capabilities
      [UserCapability::CAPABILITY_SCREEN_SCRAPER]
    end
end
