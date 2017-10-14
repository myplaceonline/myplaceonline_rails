class VehiclesController < MyplaceonlineController
  def may_upload
    true
  end

  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.vehicles.add_vehicle_service"),
        link: new_vehicle_vehicle_service_path(@obj),
        icon: "plus"
      },
      {
        title: I18n.t("myplaceonline.vehicles.vehicle_services"),
        link: vehicle_vehicle_services_path(@obj),
        icon: "bars"
      },
    ]
  end
  
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    obj.year
  end
    
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.vehicles.name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(vehicles.name)"]
    end

    def obj_params
      params.require(:vehicle).permit(
        :name,
        :notes,
        :owned_start,
        :owned_end,
        :vin,
        :bought_miles,
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
        recreational_vehicle_attributes: RecreationalVehiclesController.param_names,
        vehicle_loans_attributes: [
          :id,
          :_destroy,
          loan_attributes: Loan.params
        ],
        vehicle_services_attributes: VehicleServicesController.param_names,
        vehicle_insurances_attributes: [
          :id,
          :insurance_name,
          :started,
          :notes,
          :_destroy,
          company_attributes: Company.param_names,
          periodic_payment_attributes: PeriodicPaymentsController.param_names
        ],
        vehicle_pictures_attributes: FilesController.multi_param_names,
        vehicle_warranties_attributes: [
          :id,
          :_destroy,
          warranty_attributes: Warranty.params
        ],
        vehicle_registrations_attributes: VehicleRegistration.params
      )
    end
end
