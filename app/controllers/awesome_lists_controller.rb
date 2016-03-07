class AwesomeListsController < MyplaceonlineController
  protected
    def sorts
      ["awesome_lists.updated_at DESC"]
    end

    def obj_params
      params.require(:awesome_list).permit(
        :notes,
        location_attributes: LocationsController.param_names,
        awesome_list_items_attributes: [:id, :_destroy, :item_name]
      )
    end
end
