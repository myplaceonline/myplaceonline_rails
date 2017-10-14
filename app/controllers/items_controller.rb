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

    def additional_sorts
      [
        [I18n.t("myplaceonline.items.item_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(items.item_name)"]
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
