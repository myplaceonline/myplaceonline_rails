class JobMyreferencesController < MyplaceonlineController
  def path_name
    "job_job_myreference"
  end

  def form_path
    "job_myreferences/form"
  end

  def nested
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.jobs.job"),
        link: job_path(@parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.jobs.job"),
        link: job_path(@obj.job),
        icon: "back"
      }
    ]
  end
  
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year_simple(obj.created_at, User.current_user)
  end

  protected
    def insecure
      true
    end

    def obj_params
      params.require(:job_myreference).permit(
        myreference_attributes: MyreferencesController.param_names
      )
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      Job
    end
end
