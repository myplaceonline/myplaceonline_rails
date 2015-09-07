class ShoppingListsController < MyplaceonlineController
  def show
    @all_items = @obj.all_shopping_list_items
    render :generate
  end
  
  def generate
    set_obj
    
    @all_items = @obj.all_shopping_list_items
    
    respond_with(@obj)
  end

  protected
    def sorts
      ["lower(shopping_lists.shopping_list_name) ASC"]
    end

    def obj_params
      params.require(:shopping_list).permit(
        :shopping_list_name,
        shopping_list_items_attributes: [
          :id,
          :_destroy,
          :shopping_list_item_name,
          :position
        ]
      )
    end
end
