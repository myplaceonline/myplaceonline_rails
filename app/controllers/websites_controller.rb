class WebsitesController < MyplaceonlineController
  def index
    @to_visit = params[:to_visit]
    if !@to_visit.blank?
      @to_visit = @to_visit.to_bool
    end
    super
  end

  def self.param_names
    [
      :title,
      :url,
      :to_visit
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

    def all_additional_sql
      if @to_visit
        "and to_visit = true"
      else
        nil
      end
    end
end
