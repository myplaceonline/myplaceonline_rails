class RecreationalVehiclesController < MyplaceonlineController
  def model
    RecreationalVehicle
  end

  def display_obj(obj)
    obj.rv_name
  end

  def self.param_names(params)
    [
      :rv_name,
      :notes,
      :owned_start,
      :owned_end,
      :vin,
      :manufacturer,
      :model,
      :year,
      :price,
      :dimensions_type,
      :msrp,
      :purchased,
      :wet_weight,
      :weight_type,
      :sleeps,
      :exterior_length,
      :exterior_width,
      :exterior_height,
      :exterior_height_over,
      :interior_height,
      :liquid_capacity_type,
      :fresh_tank,
      :grey_tank,
      :black_tank,
      :warranty_ends,
      :water_heater,
      :propane,
      :volume_type,
      :refrigerator,
      Myp.select_or_create_permit(params[:recreational_vehicle], :location_purchased_attributes, LocationsController.param_names),
      recreational_vehicle_loans_attributes: [
        :id,
        :_destroy,
        loan_attributes: Loan.params
      ]
    ]
  end

  protected
    def sorts
      ["lower(recreational_vehicles.rv_name) ASC"]
    end

    def obj_params
      params.require(:recreational_vehicle).permit(RecreationalVehiclesController.param_names(params))
    end
end
