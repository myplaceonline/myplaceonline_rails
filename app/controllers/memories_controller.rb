class MemoriesController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(memories.memory_name) ASC"]
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
