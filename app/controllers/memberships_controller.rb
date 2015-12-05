class MembershipsController < MyplaceonlineController
  def self.reject_if_blank(attributes)
    result = attributes.dup.all?{|key, value|
      if key == "periodic_payment_attributes"
        PeriodicPaymentsController.reject_if_blank(value)
      else
        value.blank?
      end
    }
    result
  end

  def self.param_names(params)
    [
      :name,
      :start_date,
      :end_date,
      :notes,
      Myp.select_or_create_permit(params, :periodic_payment_attributes, PeriodicPaymentsController.param_names(params[:periodic_payment_attributes]))
    ]
  end

  protected
    def sorts
      ["lower(memberships.name) ASC"]
    end

    def obj_params
      params.require(:membership).permit(
        MembershipsController.param_names(params[:membership])
      )
    end
end
