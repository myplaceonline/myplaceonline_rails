class WebsitesController < MyplaceonlineController
  def index
    @to_visit = params[:to_visit]
    if !@to_visit.blank?
      @to_visit = @to_visit.to_bool
    end
    
    @categories = ApplicationRecord.connection.execute("select distinct website_category from websites where website_category is not null and identity_id = #{current_user.current_identity.id} order by website_category").map{|row| row["website_category"] }
    
    @categories.each do |category|
      
      instance_name = "category_" + Myp.string_to_variable_name(category)
      instance_value = nil
      
      if !params[instance_name.to_sym].blank?
        instance_value = params[instance_name.to_sym].to_bool
      end
      
      instance_variable_set("@" + instance_name, instance_value)
    end
    
    super
  end

  def self.param_names(include_website: true, include_company: true)
    [
      :id,
      :_destroy,
      :title,
      :url,
      :to_visit,
      :notes,
      :website_category,
      website_passwords_attributes: [
        :id,
        :_destroy,
        password_attributes: PasswordsController.param_names + [:id]
      ],
      recommender_attributes: ContactsController.param_names(include_website: false, include_company: include_company)
    ]
  end
  
  def index_filters
    super + [
      {
        :name => :to_visit,
        :display => "myplaceonline.websites.to_visit"
      }
    ] + @categories.dup.delete_if{|category| category.blank?}.map{|category| { name: "category_" + Myp.string_to_variable_name(category), display: category } }
  end
  
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.websites.title"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(websites.title)"]
    end

    def obj_params
      params.require(:website).permit(
        WebsitesController.param_names
      )
    end

    def all_additional_sql(strict)
      if @to_visit && !strict
        result = "and to_visit = true"
      else
        result = nil
      end
      
      if !strict
        @categories.each do |category|
          instance_name = "category_" + Myp.string_to_variable_name(category)
          if instance_variable_get("@" + instance_name)
            result = Myp.appendstr(result, "website_category = " + ActiveRecord::Base.connection.quote(category), " ", leftwrap = " and ")
          end
        end
      end
      
      result
    end
end
