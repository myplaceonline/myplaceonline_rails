class ItemsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_month_year_simple(obj.expires, User.current_user)
  end
    
  protected
    def insecure
      true
    end

    def sorts
      ["lower(items.item_name) ASC"]
    end

    def obj_params
      params.require(:item).permit(
        :item_name,
        :notes,
        :item_location,
        :cost,
        :acquired,
        :expires,
        item_files_attributes: FilesController.multi_param_names
      )
    end
end
