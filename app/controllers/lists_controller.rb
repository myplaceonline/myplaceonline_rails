class ListsController < MyplaceonlineController
  def self.param_names
    [
      :id,
      :_destroy,
      :name,
      list_items_attributes: [:id, :name, :_destroy]
    ]
  end

  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.lists.name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(lists.name)"]
    end

    def obj_params
      params.require(:list).permit(ListsController.param_names)
    end
end
