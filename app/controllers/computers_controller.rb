class ComputersController < MyplaceonlineController
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.computers.computer_model"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(computers.computer_model)"]
    end

    def obj_params
      params.require(:computer).permit(
        :purchased,
        :price,
        :computer_model,
        :serial_number,
        :max_resolution_width,
        :max_resolution_height,
        :ram,
        :num_cpus,
        :num_cores_per_cpu,
        :hyperthreaded,
        :max_cpu_speed,
        :notes,
        :dimensions_type,
        :width,
        :height,
        :depth,
        :weight_type,
        :weight,
        :hostname,
        manufacturer_attributes: Company.param_names,
        administrator_attributes: PasswordsController.param_names,
        main_user_attributes: PasswordsController.param_names,
        hard_drive_password_attributes: PasswordsController.param_names,
        computer_ssh_keys_attributes: [
          :id,
          :_destroy,
          :username,
          ssh_key_attributes: SshKeysController.param_names
        ]
      )
    end
end
