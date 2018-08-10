class PeriodicPaymentsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:monthly_total]

  def may_upload
    true
  end
  
  def monthly_total
    @total = 0
    @weekly_food = 0
    @tax_percentage = 30
    @weekly_misc = 0
    @monthly_misc = 0
    @weekly_transportation = 0
    
    all.each do |x|
      if !x.payment_amount.nil?
        if Myp.includes_today?(x.started, x.ended)
          if x.date_period == Myp::PERIOD_MONTHLY
            @total += x.payment_amount
          elsif x.date_period == Myp::PERIOD_YEARLY
            @total += x.payment_amount / 12
          elsif x.date_period == Myp::PERIOD_SIX_MONTHS
            @total += x.payment_amount / 6
          end
        end
      end
    end
    if !params[:weekly_food].nil?
      @weekly_food = params[:weekly_food].to_i
      @tax_percentage = params[:tax_percentage].to_i
      @weekly_misc = params[:weekly_misc].to_i
      @monthly_misc = params[:monthly_misc].to_i
      @weekly_transportation = params[:weekly_transportation].to_i
    end
    @total += (@weekly_food * 4) + (@weekly_misc * 4) + (@weekly_transportation * 4) + @monthly_misc
    @yearly_total = @total * 12
    
    # after_tax = salary * (1 - tax)
    #
    # after_tax in this case is the same as @yearly_total,
    # and we want to solve for salary (which in this case is @yearly_salary_needed_pretax)
    # so we just solve for salary
    
    @yearly_salary_needed_pretax = @yearly_total / (1.0 - (@tax_percentage / 100.0))
  end

  def self.param_names
    [
      :id,
      :_destroy,
      :periodic_payment_name,
      :notes,
      :started,
      :ended,
      :date_period,
      :payment_amount,
      :suppress_reminder,
      password_attributes: PasswordsController.param_names,
      periodic_payment_instances_attributes: PeriodicPaymentInstance.params,
      periodic_payment_files_attributes: FilesController.multi_param_names,
    ]
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.periodic_payments.monthly_total"),
        link: periodic_payments_monthly_total_path,
        icon: "clock"
      }
    ]
  end
  
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.periodic_payments.periodic_payment_name"), default_sort_columns[0]],
        [I18n.t("myplaceonline.periodic_payments.payment_amount"), "#{model.table_name}.payment_amount"],
      ]
    end

    def default_sort_columns
      ["lower(periodic_payments.periodic_payment_name)"]
    end

    def obj_params
      params.require(:periodic_payment).permit(
        PeriodicPaymentsController.param_names
      )
    end

    def all_additional_sql(strict)
      result = super(strict)
      if !strict
        if result.nil?
          result = ""
        end
        result += " and (ended is null or ended > current_date)"
      end
      result
    end
end
