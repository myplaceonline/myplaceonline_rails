class WirelessNetworksController < MyplaceonlineController
  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    obj.location.nil? ? nil : obj.location.display_simple
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
        [I18n.t("myplaceonline.wireless_networks.network_names"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["wireless_networks.network_names"]
    end

    def obj_params
      params.require(:wireless_network).permit(
        :network_names,
        :notes,
        password_attributes: PasswordsController.param_names,
        location_attributes: LocationsController.param_names,
      )
    end

    def all_joins
      "INNER JOIN locations ON locations.id = wireless_networks.location_id"
    end

    def all_includes
      :location
    end

    def show_map?
      true
    end
end
