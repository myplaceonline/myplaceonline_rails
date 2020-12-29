class SshKeysController < MyplaceonlineController
  
  def self.param_names
    [
      :id,
      :ssh_key_name,
      :ssh_public_key,
      :ssh_private_key,
      :encrypt,
      :notes,
      password_attributes: PasswordsController.param_names
    ]
  end
  
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.ssh_keys.ssh_key_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(ssh_keys.ssh_key_name)"]
    end

    def obj_params
      params.require(:ssh_key).permit(SshKeysController.param_names)
    end

    def sensitive
      true
    end
end
