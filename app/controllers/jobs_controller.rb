class JobsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:resume]
  
  def resume
    @jobs = all.order(sorts_wrapper).to_a.delete_if{|x| x.started.nil?}
    @educations = Myp.model_instances(
      Education,
      current_user.primary_identity,
      orders: ["educations.education_end DESC"]
    ).to_a.delete_if{|x| x.education_end.nil?}
  end

  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year(obj.started, User.current_user)
  end
    
  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.jobs.add_salary"),
        link: new_job_job_salary_path(@obj),
        icon: "plus"
      },
      {
        title: I18n.t("myplaceonline.jobs.job_salaries"),
        link: job_job_salaries_path(@obj),
        icon: "bars"
      },
      {
        title: I18n.t("myplaceonline.jobs.add_review"),
        link: new_job_job_review_path(@obj),
        icon: "plus"
      },
      {
        title: I18n.t("myplaceonline.jobs.reviews"),
        link: job_job_reviews_path(@obj),
        icon: "bars"
      },
      {
        title: I18n.t("myplaceonline.jobs.add_myreference"),
        link: new_job_job_myreference_path(@obj),
        icon: "plus"
      },
      {
        title: I18n.t("myplaceonline.jobs.myreferences"),
        link: job_job_myreferences_path(@obj),
        icon: "bars"
      },
      {
        title: I18n.t("myplaceonline.jobs.add_accomplishment"),
        link: new_job_job_accomplishment_path(@obj),
        icon: "plus"
      },
      {
        title: I18n.t("myplaceonline.jobs.accomplishments"),
        link: job_job_accomplishments_path(@obj),
        icon: "bars"
      },
      {
        title: I18n.t("myplaceonline.jobs.add_award"),
        link: new_job_job_award_path(@obj),
        icon: "plus"
      },
      {
        title: I18n.t("myplaceonline.jobs.awards"),
        link: job_job_awards_path(@obj),
        icon: "bars"
      },
    ]
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.jobs.resume"),
        link: jobs_resume_path,
        icon: "info"
      }
    ]
  end
  
  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.jobs.started"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["jobs.started"]
    end

    def obj_params
      params.require(:job).permit(
        :job_title,
        :started,
        :ended,
        :notes,
        :days_holiday,
        :days_vacation,
        :employee_identifier,
        :department_name,
        :division_name,
        :business_unit,
        :email,
        :internal_mail_id,
        :internal_mail_server,
        :department_identifier,
        :division_identifier,
        :personnel_code,
        :hours_per_week,
        company_attributes: Company.param_names,
        internal_address_attributes: LocationsController.param_names,
        job_managers_attributes: [
          :id,
          :_destroy,
          :start_date,
          :end_date,
          :notes,
          contact_attributes: ContactsController.param_names
        ],
        job_files_attributes: FilesController.multi_param_names
      )
    end
end
