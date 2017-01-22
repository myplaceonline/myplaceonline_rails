class GunsController < MyplaceonlineController
  def may_upload
    true
  end
  
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
        gun_files_attributes: FilesController.multi_param_names,
        gun_registrations_attributes: GunRegistration.params
      )
    end
end
