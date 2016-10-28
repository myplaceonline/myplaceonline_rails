class RecreationalVehicleServicesController < MyplaceonlineController
  def path_name
    "recreational_vehicle_recreational_vehicle_service"
  end

  def form_path
    "recreational_vehicle_services/form"
  end

  def nested
    true
  end

  def footer_items_index
    [
      {
        title: I18n.t("myplaceonline.recreational_vehicle_services.recreational_vehicle"),
        link: recreational_vehicle_path(@parent),
        icon: "back"
      }
    ] + super
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.recreational_vehicle_services.recreational_vehicle"),
        link: recreational_vehicle_path(@obj.recreational_vehicle),
        icon: "back"
      }
    ] + super
  end

  def self.param_names
    [
      :id,
      :short_description,
      :date_due,
      :date_serviced,
      :miles,
      :service_location,
      :notes,
      :_destroy,
      recreational_vehicle_service_files_attributes: FilesController.multi_param_names
    ]
  end

  def use_bubble?
    true
  end

  def bubble_text(obj)
    Myp.display_date(obj.date_serviced, current_user)
  end

  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["recreational_vehicle_services.date_serviced DESC"]
    end

    def obj_params
      params.require(:recreational_vehicle_service).permit(RecreationalVehicleServicesController.param_names)
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
