class PaidTaxesController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:totals]

  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    result = nil
    if !obj.total_taxes_paid.nil?
      result = "#{Myp.number_to_currency(obj.total_taxes_paid)}"
      if !obj.agi.nil?
        result = Myp.appendstr(result, "#{Myp.number_to_currency(obj.agi)}", "/")
      end
    end
    result
  end

  def totals
    @total_taxes = 0
    @total_agi = 0
    @percent_paid = 0
    
    all.each do |paid_tax|
      if !paid_tax.total_taxes_paid.nil? && !paid_tax.agi.nil?
        @total_taxes = @total_taxes + paid_tax.total_taxes_paid
        @total_agi = @total_agi + paid_tax.agi
      end
    end
    
    if @total_agi > 0
      @percent_paid = "#{Myp.decimal_to_s(value: (@total_taxes / @total_agi) * 100.0)}%"
    end
  end
  
  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.paid_taxes.totals"),
        link: paid_taxes_totals_path,
        icon: "info"
      },
    ]
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
        [I18n.t("myplaceonline.paid_taxes.fiscal_year"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["paid_taxes.fiscal_year"]
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
