class MypletsController < MyplaceonlineController
  def show_index_footer
    false
  end
  
  def show_add
    false
  end
  
  def after_create_or_update
    set_category_obj
    controller_class = @obj.category_name + "_controller"
    controller = Object.const_get(controller_class.camelize)
    if controller.respond_to?("permit_params")
      @category_obj.assign_attributes(params["myplet"].require(@obj.category_name.singularize).permit(
        controller.permit_params
      ))
      @category_obj.save!
    end
    
    super
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
    
    def sorts
      ["lower(myplets.title) ASC"]
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
