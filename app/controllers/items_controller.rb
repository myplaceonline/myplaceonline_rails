class ItemsController < MyplaceonlineController
  def may_upload
    true
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
        item_files_attributes: FilesController.multi_param_names
      )
    end
end
