class PaidTaxesController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year_simple(obj.paid_tax_date, User.current_user)
  end

  protected
    def sorts
      ["paid_taxes.paid_tax_date DESC"]
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
        paid_tax_files_attributes: FilesController.multi_param_names,
        password_attributes: PasswordsController.param_names
      )
    end
end
