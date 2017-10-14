class DentalInsurancesController < MyplaceonlineController
  def self.param_names
    [
      :id,
      :_destroy,
      :insurance_name,
      :notes,
      :account_number,
      :group_number,
      password_attributes: PasswordsController.param_names,
      insurance_company_attributes: Company.param_names,
      periodic_payment_attributes: PeriodicPaymentsController.param_names,
      group_company_attributes: Company.param_names,
      doctor_attributes: DoctorsController.param_names,
      dental_insurance_files_attributes: FilesController.multi_param_names
    ]
  end

  def may_upload
    true
  end

  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.dental_insurances.insurance_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(dental_insurances.insurance_name)"]
    end

    def obj_params
      params.require(:dental_insurance).permit(
        DentalInsurancesController.param_names
      )
    end

    def sensitive
      true
    end
end
