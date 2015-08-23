class ListsController < MyplaceonlineController
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
end
