class VehiclesController < MyplaceonlineController
  def model
    Vehicle
  end

  def display_obj(obj)
    obj.name
  end

  protected
    def sorts
      ["lower(vehicles.name) ASC"]
    end

    def obj_params
      params.require(:vehicle).permit(
        :name,
        :notes,
        :owned_start,
        :owned_end,
        :vin,
        :manufacturer,
        :model,
        :year,
        :color,
        :license_plate,
        :region,
        :sub_region1,
        vehicle_loans_attributes: [:id, :lender, :amount, :start, :paid_off, :monthly_payment, :_destroy],
        vehicle_services_attributes: [:id, :short_description, :date_due, :date_serviced, :miles, :service_location, :cost, :notes]
      )
    end
end
