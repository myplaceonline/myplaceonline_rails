class ImportsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(imports.import_name) ASC"]
    end

    def obj_params
      params.require(:import).permit(
        :import_name,
        :import_type,
        :notes,
        import_files_attributes: FilesController.multi_param_names,
      )
    end
end
