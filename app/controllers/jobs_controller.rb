class JobsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year(obj.started, User.current_user)
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
        company_attributes: CompaniesController.param_names,
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
