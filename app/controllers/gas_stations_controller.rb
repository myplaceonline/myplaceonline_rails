class GasStationsController < MyplaceonlineController
  protected
    def sorts
      ["gas_stations.updated_at DESC"]
    end
    
    def obj_params
      params.require(:gas_station).permit(
        :gas,
        :diesel,
        :propane_replacement,
        :propane_fillup,
        location_attributes: LocationsController.param_names
      )
    end
end
