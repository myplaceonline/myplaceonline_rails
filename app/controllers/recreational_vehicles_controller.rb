class RecreationalVehiclesController < MyplaceonlineController
  def may_upload
    true
  end

  def self.param_names
    [
      :id,
      :_destroy,
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
      :exterior_length_over,
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
      :slideouts_extra_width,
      :floor_length,
      location_purchased_attributes: LocationsController.param_names,
      recreational_vehicle_loans_attributes: [
        :id,
        :_destroy,
        loan_attributes: Loan.params
      ],
      recreational_vehicle_pictures_attributes: FilesController.multi_param_names,
      recreational_vehicle_insurances_attributes: [
        :id,
        :insurance_name,
        :started,
        :notes,
        :_destroy,
        company_attributes: CompaniesController.param_names,
        periodic_payment_attributes: PeriodicPaymentsController.param_names
      ]
    ]
  end
  
  def self.reject_if_blank(attributes)
    attributes.dup.delete_if {|key, value| key.to_s == "dimensions_type" || key.to_s == "weight_type" || key.to_s == "liquid_capacity_type" || key.to_s == "volume_type" || key.to_s == "location_purchased_attributes" }.all? {|key, value| value.blank?}
  end

  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.recreational_vehicles.add_recreational_vehicle_measurement"),
        link: new_recreational_vehicle_recreational_vehicle_measurement_path(@obj),
        icon: "plus"
      },
      {
        title: I18n.t("myplaceonline.recreational_vehicles.recreational_vehicle_measurements"),
        link: recreational_vehicle_recreational_vehicle_measurements_path(@obj),
        icon: "bars"
      },
      {
        title: I18n.t("myplaceonline.recreational_vehicles.add_recreational_vehicle_service"),
        link: new_recreational_vehicle_recreational_vehicle_service_path(@obj),
        icon: "plus"
      },
      {
        title: I18n.t("myplaceonline.recreational_vehicles.recreational_vehicle_services"),
        link: recreational_vehicle_recreational_vehicle_services_path(@obj),
        icon: "bars"
      },
    ]
  end

  protected
    def sorts
      ["lower(recreational_vehicles.rv_name) ASC"]
    end

    def obj_params
      params.require(:recreational_vehicle).permit(RecreationalVehiclesController.param_names)
    end
end
