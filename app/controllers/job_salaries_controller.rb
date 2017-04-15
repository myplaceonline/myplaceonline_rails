class JobSalariesController < MyplaceonlineController
  def path_name
    "job_job_salary"
  end

  def form_path
    "job_salaries/form"
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
    Myp.display_date_month_year_simple(obj.started, User.current_user)
  end

  protected
    def insecure
      true
    end

    def sorts
      ["job_salaries.started DESC"]
    end

    def obj_params
      params.require(:job_salary).permit(
        :started,
        :ended,
        :notes,
        :salary,
        :salary_period,
        :new_title,
        :hours_per_week
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
