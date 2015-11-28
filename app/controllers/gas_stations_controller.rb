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
        Myp.select_or_create_permit(params[:gas_station], :location_attributes, LocationsController.param_names)
      )
    end
end
