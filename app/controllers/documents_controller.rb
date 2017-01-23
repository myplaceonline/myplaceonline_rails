class DocumentsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    Myp.display_date_short_year(obj.document_date, User.current_user)
  end

  protected
    def insecure
      true
    end

    def sorts
      ["documents.document_date DESC NULLS LAST", "lower(documents.document_name) DESC"]
    end

    def obj_params
      params.require(:document).permit(
        :document_name,
        :document_category,
        :notes,
        :important,
        :document_date,
        document_files_attributes: FilesController.multi_param_names
      )
    end
end
