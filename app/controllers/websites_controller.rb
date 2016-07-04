class WebsitesController < MyplaceonlineController
  def index
    @to_visit = params[:to_visit]
    if !@to_visit.blank?
      @to_visit = @to_visit.to_bool
    end
    super
  end

  def self.param_names(include_website: true)
    [
      :id,
      :_destroy,
      :title,
      :url,
      :to_visit,
      :notes,
      website_passwords_attributes: [
        :id,
        :_destroy,
        password_attributes: PasswordsController.param_names + [:id]
      ],
      recommender_attributes: ContactsController.param_names(include_website: false)
    ]
  end
  
  def self.reject_if_blank(attributes)
    attributes.dup.delete_if {|key, value| key.to_s == "to_visit" }.all?{|key, value|
      if key == "password_attributes"
        PasswordsController.reject_if_blank(value)
      elsif key == "recommender_attributes"
        ContactsController.reject_if_blank(value)
      else
        value.blank?
      end
    }
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

    def all_additional_sql(strict)
      if @to_visit && !strict
        "and to_visit = true"
      else
        nil
      end
    end
end
