class MemoriesController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.memories.memory_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(memories.memory_name)"]
    end

    def obj_params
      params.require(:memory).permit(
        :memory_name,
        :memory_date,
        :feeling,
        :notes,
        memory_files_attributes: FilesController.multi_param_names
      )
    end
end
