class WisdomsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.wisdoms.name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(wisdoms.name)"]
    end

    def obj_params
      params.require(:wisdom).permit(
        :name,
        :notes,
        wisdom_files_attributes: FilesController.multi_param_names
      )
    end
end
