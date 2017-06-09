class WebsiteScrapersController < MyplaceonlineController
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.website_scrapers.scrape"),
        link: add_token(website_scraper_scrape_path(@obj)),
        icon: "action"
      }
    ] + super + [
      {
        title: I18n.t("myplaceonline.website_scrapers.test"),
        link: website_scraper_test_path(@obj),
        icon: "action"
      }
    ]
  end
  
  def scrape
    set_obj
      
    execute_scrape(escape: false)
    content_type = @obj.content_type
    if content_type.blank?
      content_type = "text/html"
    end
    render(layout: false, content_type: content_type)
  end
  
  def test
    set_obj
      
    execute_scrape(escape: true)
  end
  
  protected
    def execute_scrape(escape:)
      begin
        results = Myp.http_get(url: @obj.website_url)
        
        @raw_response = process_results(results[:body])
        
        if escape
          @raw_response = CGI::escapeHTML(@raw_response)
          @raw_response = @raw_response.gsub(/\n/, "\n<br />")
        end
      rescue => e
        flash[:error] = t("myplaceonline.website_scrapers.scrape_error", message: e.to_s)
      end
    end
    
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
        :notes,
        :content_type,
        website_scraper_transformations_attributes: WebsiteScraperTransformation.params,
      )
    end

    def required_capabilities
      [UserCapability::CAPABILITY_SCREEN_SCRAPER]
    end
    
    def process_results(results)
      @obj.website_scraper_transformations.each do |t|
        results = t.execute_transform(results)
      end
      results
    end

    def publicly_shareable_actions
      [:show, :scrape]
    end
end
