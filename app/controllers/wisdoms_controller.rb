class WisdomsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(wisdoms.name) ASC"]
    end

    def obj_params
      params.require(:wisdom).permit(
        :name,
        :notes,
        wisdom_files_attributes: FilesController.multi_param_names
      )
    end
end
