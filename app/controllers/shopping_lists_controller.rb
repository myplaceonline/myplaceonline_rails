class ShoppingListsController < MyplaceonlineController
  def show
    @all_items = @obj.all_shopping_list_items
    super
  end
  
  def show_created_updated
    false
  end
  
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.shopping_lists.shopping_list_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(shopping_lists.shopping_list_name)"]
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
