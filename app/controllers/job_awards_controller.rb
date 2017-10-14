class JobAwardsController < MyplaceonlineController
  def path_name
    "job_job_award"
  end

  def form_path
    "job_awards/form"
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
    Myp.display_date_month_year_simple(obj.job_award_date, User.current_user)
  end

  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.job_awards.job_award_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["job_awards.job_award_date"]
    end

    def obj_params
      params.require(:job_award).permit(
        :job_award_description,
        :job_award_date,
        :job_award_amount,
        :notes,
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
