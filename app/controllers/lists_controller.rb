class ListsController < MyplaceonlineController
  def model
    List
  end

  def display_obj(obj)
    obj.name
  end
  
  def self.param_names
    [
      :name,
      {
        list_items_attributes: [:id, :name, :_destroy]
      }
    ]
  end

  protected
    def sorts
      ["lower(lists.name) ASC"]
    end

    def obj_params
      params.require(:list).permit(ListsController.param_names)
    end
    
    def update_presave
      check_nested_attributes(@obj, :list_items, :list)
    end
end
