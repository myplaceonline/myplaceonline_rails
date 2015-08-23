class VehiclesController < MyplaceonlineController
  def model
    Vehicle
  end

  def may_upload
    true
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
        :trim_name,
        :dimensions_type,
        :height,
        :width,
        :length,
        :wheel_base,
        :ground_clearance,
        :doors,
        :bed_length,
        :weight_type,
        :doors_type,
        :passenger_seats,
        :gvwr,
        :gcwr,
        :gawr_front,
        :gawr_rear,
        :front_axle_details,
        :front_axle_rating,
        :front_suspension_details,
        :front_suspension_rating,
        :rear_axle_details,
        :rear_axle_rating,
        :rear_suspension_details,
        :rear_suspension_rating,
        :tire_details,
        :tire_rating,
        :tire_diameter,
        :wheel_details,
        :wheel_rating,
        :engine_type,
        :wheel_drive_type,
        :wheels_type,
        :fuel_tank_capacity_type,
        :fuel_tank_capacity,
        :wet_weight_front,
        :wet_weight_rear,
        :tailgate_weight,
        :horsepower,
        :cylinders,
        :displacement_type,
        :displacement,
        :price,
        :msrp,
        Myp.select_or_create_permit(params[:vehicle], :recreational_vehicle_attributes, RecreationalVehiclesController.param_names(params[:vehicle][:recreational_vehicle_attributes])),
        vehicle_loans_attributes: [
          :id,
          :_destroy,
          loan_attributes: Loan.params
        ],
        vehicle_services_attributes: [
          :id,
          :short_description,
          :date_due,
          :date_serviced,
          :miles,
          :service_location,
          :cost,
          :notes,
          :_destroy
        ],
        vehicle_insurances_attributes: [
          :id,
          :insurance_name,
          :started,
          :notes,
          :_destroy,
          company_attributes: CompaniesController.param_names(params[:vehicle][:vehicle_insurances_attributes]) + [:id],
          periodic_payment_attributes: PeriodicPaymentsController.param_names(params[:vehicle][:vehicle_insurances_attributes]) + [:id]
        ],
        vehicle_pictures_attributes: [
          :id,
          :_destroy,
          identity_file_attributes: [
            :id,
            :file,
            :notes
          ]
        ],
        vehicle_warranties_attributes: [
          :id,
          :_destroy,
          warranty_attributes: Warranty.params
        ],
      )
    end
end
