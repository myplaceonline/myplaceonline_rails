class JobReviewsController < MyplaceonlineController
  def path_name
    "job_job_review"
  end

  def form_path
    "job_reviews/form"
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
    Myp.display_date_month_year_simple(obj.review_date, User.current_user)
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
        [I18n.t("myplaceonline.job_reviews.review_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["job_reviews.review_date"]
    end

    def obj_params
      params.require(:job_review).permit(
        :review_date,
        :company_score,
        :notes,
        :self_evaluation,
        contact_attributes: ContactsController.param_names,
        job_review_files_attributes: FilesController.multi_param_names
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
