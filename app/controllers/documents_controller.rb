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
  
  def self.param_names
    [
      :document_name,
      :document_category,
      :notes,
      :important,
      :document_date,
      :coauthors,
      document_files_attributes: FilesController.multi_param_names,
    ]
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
        [I18n.t("myplaceonline.documents.document_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["documents.document_date", "lower(documents.document_name) DESC"]
    end

    def obj_params
      params.require(:document).permit(DocumentsController.param_names)
    end
end
