class TestObjectsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(test_objects.test_object_name) ASC"]
    end

    def obj_params
      params.require(:test_object).permit(
        :test_object_name,
        :notes,
        test_object_files_attributes: FilesController.multi_param_names
      )
    end
end
