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
      
      results[:body] = process_results(results[:body])
      
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
        :notes,
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
#       while true do
#         match_data = markdown.match(/\[([^\]]+)\]\(([^)]+)\)/, i)
#         if !match_data.nil?
#           if match_data[1] == match_data[2]
#             replacement = match_data[1]
#           else
#             replacement = match_data[1] + " (" + match_data[2] + ")"
#           end
#           markdown = match_data.pre_match + replacement + match_data.post_match
#           i = match_data.offset(0)[0] + replacement.length + 1
#         else
#           break
#         end
#       end
  #https://stackoverflow.com/questions/5239997/regex-how-to-match-multiple-lines#5240101    
# <div class="date">June 7, 2017</div>
# <a href="http://econlog.econlib.org/archives/2017/06/unfortunately_i.html" class="title">Unfortunately, I Win My Obama Immigration Bet</a>
# <br/>
# <div class="hosted">Bryan Caplan</div> 
      results
    end
end
