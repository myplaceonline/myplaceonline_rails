class ArtsController < MyplaceonlineController
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

    def default_sort_columns
      ["arts.art_name"]
    end

    def obj_params
      params.require(:art).permit(
        :art_name,
        :art_source,
        :art_link,
        :notes,
        art_files_attributes: FilesController.multi_param_names,
      )
    end
end
