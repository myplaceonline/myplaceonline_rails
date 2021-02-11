class LocksController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def default_sort_columns
      ["locks.lock_name"]
    end

    def obj_params
      params.require(:lock).permit(
        :lock_name,
        :notes,
        lock_files_attributes: FilesController.multi_param_names,
        location_attributes: LocationsController.param_names,
        password_attributes: PasswordsController.param_names
      )
    end
end
