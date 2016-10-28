class DocumentsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(documents.document_name) DESC"]
    end

    def obj_params
      params.require(:document).permit(
        :document_name,
        :document_category,
        :notes,
        document_files_attributes: FilesController.multi_param_names
      )
    end
end
