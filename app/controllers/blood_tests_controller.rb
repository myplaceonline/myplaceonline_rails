class BloodTestsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def sorts
      ["blood_tests.fast_started DESC"]
    end

    def obj_params
      params.require(:blood_test).permit(
        :fast_started,
        :test_time,
        :notes,
        blood_test_files_attributes: FilesController.multi_param_names,
        blood_test_results_attributes: [
          :id,
          :_destroy,
          :concentration,
          blood_concentration_attributes: BloodConcentration.params
        ]
      )
    end
end
