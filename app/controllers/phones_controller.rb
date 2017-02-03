class PhonesController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def sorts
      ["lower(phones.phone_model_name) ASC"]
    end

    def obj_params
      params.require(:phone).permit(
        :phone_model_name,
        :phone_number,
        :purchased,
        :price,
        :operating_system,
        :operating_system_version,
        :max_resolution_width,
        :max_resolution_height,
        :ram,
        :num_cpus,
        :num_cores_per_cpu,
        :hyperthreaded,
        :max_cpu_speed,
        :cdma,
        :gsm,
        :front_camera_megapixels,
        :back_camera_megapixels,
        :notes,
        :dimensions_type,
        :width,
        :height,
        :depth,
        :weight_type,
        :weight,
        manufacturer_attributes: Company.param_names,
        password_attributes: PasswordsController.param_names,
        phone_files_attributes: FilesController.multi_param_names
      )
    end
end
