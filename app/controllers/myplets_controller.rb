class MypletsController < MyplaceonlineController
  def show_index_footer
    false
  end
  
  def show_add
    false
  end
  
  protected
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
