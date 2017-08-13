class TestObjectsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year_simple(obj.test_object_date, User.current_user)
  end

  def footer_items_show
    super + [
      {
        title: I18n.t("myplaceonline.test_objects.add_instance"),
        link: new_test_object_test_object_instance_path(@obj),
        icon: "plus"
      },
      {
        title: I18n.t("myplaceonline.test_objects.instances"),
        link: test_object_test_object_instances_path(@obj),
        icon: "bars"
      },
    ]
  end

  protected
    def insecure
      true
    end

    def sorts
      #["lower(test_objects.test_object_name) ASC"]
      ["test_objects.test_object_date DESC NULLS LAST"]
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
        :test_object_boolean,
        :test_object_enum,
        test_object_files_attributes: FilesController.multi_param_names,
        test_object_instances_attributes: TestObjectInstance.params,
        contact_attributes: ContactsController.param_names
      )
    end
end
