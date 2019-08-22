class TestObjectsController < MyplaceonlineController
  skip_authorization_check :only => MyplaceonlineController::DEFAULT_SKIP_AUTHORIZATION_CHECK + [:static_page]

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
    result = super
    
    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.test_objects.add_instance"),
        link: new_test_object_test_object_instance_path(@obj),
        icon: "plus"
      }
    end
    
    result << {
      title: I18n.t("myplaceonline.test_objects.instances"),
      link: test_object_test_object_instances_path(@obj),
      icon: "bars"
    }
    
    result << {
      title: I18n.t("myplaceonline.test_objects.instance_page"),
      link: test_object_instance_page_path(@obj),
      icon: "info" # http://demos.jquerymobile.com/1.4.5/icons/
    }
    
    result
  end
  
  def footer_items_index
    super + [
      {
        title: I18n.t("myplaceonline.test_objects.static_page"),
        link: test_objects_static_page_path,
        icon: "info"
      },
    ]
  end
  
  def instance_page
    set_obj
    
    @details = @obj.display

    if request.post?
      redirect_to(
        obj_path,
        flash: { notice: I18n.t("myplaceonline.test_objects.updated") }
      )
    end
  end

  def static_page
    @details = all.count.to_s
  end

  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.test_objects.test_object_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["test_objects.test_object_date"]
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
