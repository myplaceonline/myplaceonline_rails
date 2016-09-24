class PeriodicPaymentsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:monthly_total]

  def index
    @archived = params[:archived]
    if !@archived.blank?
      @archived = @archived.to_bool
    end
    super
  end

  def monthly_total
    @total = 0
    all.each do |x|
      if !x.payment_amount.nil?
        if Myp.includes_today?(x.started, x.ended)
          if x.date_period == 0
            @total += x.payment_amount
          elsif x.date_period == 1
            @total += x.payment_amount / 12
          elsif x.date_period == 2
            @total += x.payment_amount / 6
          end
        end
      end
    end
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
      :is_archived,
      password_attributes: PasswordsController.param_names
    ]
  end

  def self.reject_if_blank(attributes)
    attributes.dup.delete_if {|key, value| key.to_s == "suppress_reminder" }.all?{|key, value|
      if key == "password_attributes"
        PasswordsController.reject_if_blank(value)
      else
        value.blank?
      end
    }
  end

  def footer_items_index
    super + [
      {
        title: I18n.t('myplaceonline.periodic_payments.monthly_total'),
        link: periodic_payments_monthly_total_path,
        icon: "clock"
      }
    ]
  end
  
  protected
    def sorts
      ["lower(periodic_payments.periodic_payment_name) ASC"]
    end

    def obj_params
      params.require(:periodic_payment).permit(
        PeriodicPaymentsController.param_names
      )
    end

    def all_additional_sql(strict)
      if (@archived.blank? || !@archived) && !strict
        "and archived is null"
      else
        nil
      end
    end
end
