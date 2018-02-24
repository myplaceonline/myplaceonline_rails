class PaidTaxesController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    if !obj.total_taxes_paid.nil?
      "#{Myp.number_to_currency(obj.total_taxes_paid)}"
    else
      nil
    end
  end

  protected
    def sensitive
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.paid_taxes.paid_tax_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["paid_taxes.paid_tax_date"]
    end

    def obj_params
      params.require(:paid_tax).permit(
        :paid_tax_description,
        :paid_tax_date,
        :total_taxes_paid,
        :donations,
        :federal_refund,
        :state_refund,
        :service_fee,
        :notes,
        :agi,
        :fiscal_year,
        :federal_taxes,
        :state_taxes,
        :local_taxes,
        paid_tax_files_attributes: FilesController.multi_param_names,
        password_attributes: PasswordsController.param_names
      )
    end
end
