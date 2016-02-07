class GunsController < MyplaceonlineController
  protected
    def sorts
      ["lower(guns.gun_name) ASC"]
    end

    def obj_params
      params.require(:gun).permit(
        :gun_name,
        :gun_model,
        :manufacturer_name,
        :bullet_caliber,
        :max_bullets,
        :price,
        :purchased,
        :notes,
        gun_registrations_attributes: [
          :id,
          :_destroy,
          :registered,
          :expires,
          location_attributes: LocationsController.param_names
        ]
      )
    end
end
