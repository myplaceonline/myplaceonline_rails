class JobsController < MyplaceonlineController
  def model
    Job
  end

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
        Myp.select_or_create_permit(params[:job], :company_attributes, CompaniesController.param_names(params[:job][:company_attributes])),
        Myp.select_or_create_permit(params[:job], :manager_contact_attributes, ContactsController.param_names),
        job_salaries_attributes: [
          :id,
          :_destroy,
          :started,
          :ended,
          :notes,
          :salary,
          :salary_period
        ]
      )
    end
end
