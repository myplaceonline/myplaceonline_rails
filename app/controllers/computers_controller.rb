class ComputersController < MyplaceonlineController
  def model
    Computer
  end

  def display_obj(obj)
    obj.display
  end

  protected
    def sorts
      ["lower(computers.computer_model) ASC"]
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
        Myp.select_or_create_permit(params[:computer], :manufacturer_attributes, CompaniesController.param_names(params[:computer][:manufacturer_attributes])),
        Myp.select_or_create_permit(params[:computer], :administrator_attributes, PasswordsController.param_names),
        Myp.select_or_create_permit(params[:computer], :main_user_attributes, PasswordsController.param_names)
      )
    end
end
