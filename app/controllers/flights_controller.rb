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
        :notes
      )
    end
end
