# periodic_payment_name:string notes:text started:date ended:date date_period:integer 'payment_amount:decimal{10,2}' identity:references:index
class PeriodicPaymentsController < MyplaceonlineController
  def model
    PeriodicPayment
  end

  def display_obj(obj)
    obj.display
  end

  protected
    def sorts
      ["lower(periodic_payments.periodic_payment_name) ASC"]
    end

    def obj_params
      params.require(:periodic_payment).permit(
        :periodic_payment_name,
        :notes,
        :started,
        :ended,
        :date_period,
        :payment_amount
      )
    end
end
