class GunsController < MyplaceonlineController
  def may_upload
    true
  end
  
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.guns.gun_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(guns.gun_name)"]
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
