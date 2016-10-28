class RecreationalVehicleMeasurementsController < MyplaceonlineController
  def path_name
    "recreational_vehicle_recreational_vehicle_measurement"
  end

  def form_path
    "recreational_vehicle_measurements/form"
  end

  def nested
    true
  end

  def footer_items_index
    [
      {
        title: I18n.t("myplaceonline.recreational_vehicle_measurements.recreational_vehicle"),
        link: recreational_vehicle_path(@parent),
        icon: "back"
      }
    ] + super
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.recreational_vehicle_measurements.recreational_vehicle"),
        link: recreational_vehicle_path(@obj.recreational_vehicle),
        icon: "back"
      }
    ] + super
  end

  def self.param_names
    [
      :id,
      :_destroy,
      :measurement_name,
      :measurement_type,
      :width,
      :height,
      :depth,
      :notes
    ]
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(recreational_vehicle_measurements.measurement_name) ASC"]
    end

    def obj_params
      params.require(:recreational_vehicle_measurement).permit(RecreationalVehicleMeasurementsController.param_names)
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      RecreationalVehicle
    end
end
