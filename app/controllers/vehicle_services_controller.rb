class VehicleServicesController < MyplaceonlineController
  def path_name
    "vehicle_vehicle_service"
  end

  def form_path
    "vehicle_services/form"
  end

  def nested
    true
  end

  def footer_items_index
    [
      {
        title: I18n.t("myplaceonline.vehicle_service.vehicle"),
        link: vehicle_path(@parent),
        icon: "back"
      }
    ] + super
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.vehicle_service.vehicle"),
        link: vehicle_path(@obj.vehicle),
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
      :cost,
      :notes,
      :_destroy,
      vehicle_service_files_attributes: FilesController.multi_param_names
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

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.vehicle_services.date_serviced"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["vehicle_services.date_serviced"]
    end

    def obj_params
      params.require(:vehicle_service).permit(VehicleServicesController.param_names)
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      Vehicle
    end
end
