class MembershipsController < MyplaceonlineController
  protected
    def sorts
      ["lower(memberships.name) ASC"]
    end

    def obj_params
      params.require(:membership).permit(
        :name,
        :start_date,
        :end_date,
        :notes,
        Myp.select_or_create_permit(params[:membership], :periodic_payment_attributes, PeriodicPaymentsController.param_names(params[:membership][:periodic_payment_attributes]))
      )
    end
end
