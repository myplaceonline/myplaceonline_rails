class SubscriptionsController < MyplaceonlineController
  protected
    def sorts
      ["lower(subscriptions.name) ASC"]
    end

    def obj_params
      params.require(:subscription).permit(
        :name,
        :start_date,
        :end_date,
        :notes,
        Myp.select_or_create_permit(params[:subscription], :periodic_payment_attributes, PeriodicPaymentsController.param_names(params[:subscription][:periodic_payment_attributes]))
      )
    end
end
