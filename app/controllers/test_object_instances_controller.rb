class TestObjectInstancesController < MyplaceonlineController
  def path_name
    "test_object_test_object_instance"
  end

  def form_path
    "test_object_instances/form"
  end

  def nested
    true
  end

  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.test_object_instances.back"),
        link: test_object_path(@parent),
        icon: "back"
      }
    ]
  end
  
  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.test_object_instances.back"),
        link: test_object_path(@obj.test_object),
        icon: "back"
      }
    ] + super
  end
  
  protected
    def insecure
      true
    end

    def sorts
      ["lower(test_object_instances.test_object_instance_name) ASC"]
    end

    def obj_params
      params.require(:test_object_instance).permit(TestObjectInstance.params)
    end
    
    def has_category
      false
    end
    
    def additional_items?
      false
    end

    def parent_model
      TestObject
    end
end
