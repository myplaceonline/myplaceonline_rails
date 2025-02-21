class WearablesController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.wearables.name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["wearables.name"]
    end

    def obj_params
      params.require(:wearable).permit(
        :name,
        :notes,
        :rating,
        wearable_files_attributes: FilesController.multi_param_names,
      )
    end
end
