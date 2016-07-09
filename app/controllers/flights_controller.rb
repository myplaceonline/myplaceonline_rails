class FlightsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(flights.flight_name) ASC"]
    end

    def obj_params
      params.require(:flight).permit(
        :flight_name,
        :flight_start_date,
        :confirmation_number,
        :notes,
        flight_legs_attributes: [
          :id,
          :_destroy,
          :flight_number,
          :depart_airport_code,
          :depart_time,
          :arrival_airport_code,
          :arrive_time,
          :seat_number,
          :position,
          flight_company_attributes: CompaniesController.param_names,
          depart_location_attributes: LocationsController.param_names,
          arrival_location_attributes: LocationsController.param_names
        ]
      )
    end
end
