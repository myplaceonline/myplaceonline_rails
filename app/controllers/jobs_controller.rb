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
        title: I18n.t('myplaceonline.jobs.add_accomplishment'),
        link: new_job_job_accomplishment_path(@obj),
        icon: "plus"
      },
      {
        title: I18n.t('myplaceonline.jobs.accomplishments'),
        link: job_job_accomplishments_path(@obj),
        icon: "bars"
      },
    ]
  end

  def footer_items_index
    super + [
      {
        title: I18n.t('myplaceonline.jobs.resume'),
        link: jobs_resume_path,
        icon: "info"
      }
    ]
  end
  
  protected
    def sorts
      ["jobs.started DESC"]
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
        job_salaries_attributes: [
          :id,
          :_destroy,
          :started,
          :ended,
          :notes,
          :salary,
          :salary_period,
          :new_title,
          :hours_per_week
        ],
        job_managers_attributes: [
          :id,
          :_destroy,
          :start_date,
          :end_date,
          :notes,
          contact_attributes: ContactsController.param_names
        ],
        job_reviews_attributes: [
          :id,
          :_destroy,
          :review_date,
          :company_score,
          :notes,
          :self_evaluation,
          contact_attributes: ContactsController.param_names,
          job_review_files_attributes: FilesController.multi_param_names
        ],
        job_myreferences_attributes: [
          :id,
          :_destroy,
          myreference_attributes: MyreferencesController.param_names
        ],
        job_files_attributes: FilesController.multi_param_names
      )
    end
end
