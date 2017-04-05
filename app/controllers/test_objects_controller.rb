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
        :test_object_currency,
        :test_object_string,
        :test_object_date,
        :test_object_datetime,
        :test_object_time,
        :test_object_number,
        :test_object_decimal,
        :contact,
        test_object_files_attributes: FilesController.multi_param_names,
        test_object_instances_attributes: TestObjectInstance.params,
        contact_attributes: ContactsController.param_names
      )
    end
end
