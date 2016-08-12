class JobsController < MyplaceonlineController
  protected
    def sorts
      ["lower(jobs.job_title) ASC"]
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
        company_attributes: CompaniesController.param_names,
        manager_contact_attributes: ContactsController.param_names,
        internal_address_attributes: LocationsController.param_names,
        job_salaries_attributes: [
          :id,
          :_destroy,
          :started,
          :ended,
          :notes,
          :salary,
          :salary_period
        ],
        job_managers_attributes: [
          :id,
          :_destroy,
          :start_date,
          :end_date,
          :notes,
          contact_attributes: ContactsController.param_names
        ]
      )
    end
end
