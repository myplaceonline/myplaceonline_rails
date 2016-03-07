class SshKeysController < MyplaceonlineController
  protected
    def sorts
      ["lower(ssh_keys.ssh_key_name) ASC"]
    end

    def obj_params
      params.require(:ssh_key).permit(
        :ssh_key_name,
        :ssh_public_key,
        :ssh_private_key,
        :encrypt,
        password_attributes: PasswordsController.param_names
      )
    end

    def sensitive
      true
    end
end
