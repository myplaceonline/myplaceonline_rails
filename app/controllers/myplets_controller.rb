class MypletsController < MyplaceonlineController
  def show_index_footer
    false
  end
  
  def allow_add
    false
  end
  
  def after_update_redirect
    on_after_create_or_update
    super
  end
  
  def after_create_redirect
    on_after_create_or_update
    super
  end
  
  def on_after_create_or_update
    set_category_obj
    controller_class = @obj.category_name + "_controller"
    controller = Object.const_get(controller_class.camelize)
    if controller.respond_to?("permit_params")
      @category_obj.assign_attributes(params["myplet"].require(@obj.category_name.singularize).permit(
        controller.permit_params
      ))
      @category_obj.save!
    end
  end
  
  protected
    def set_category_obj
      if !@obj.category_name.blank? && !@obj.category_id.nil?
        @category_obj = Myp.find_existing_object(@obj.category_name.singularize, @obj.category_id)
      end
    end
  
    def edit_prerespond
      set_category_obj
    end
    
    def additional_sorts
      [
        [I18n.t("myplaceonline.myplets.title"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(myplets.title)"]
    end

    def obj_params
      params.require(:myplet).permit(
        :title,
        :category_name,
        :category_id,
        :border_type
      )
    end
    
    def additional_items?
      false
    end

    def has_category
      false
    end
end
