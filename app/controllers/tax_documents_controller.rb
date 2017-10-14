class TaxDocumentsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    obj.fiscal_year.to_s
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
        [I18n.t("myplaceonline.tax_documents.fiscal_year"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["tax_documents.fiscal_year", "lower(tax_documents.tax_document_form_name) ASC"]
    end

    def obj_params
      params.require(:tax_document).permit(
        :tax_document_form_name,
        :tax_document_description,
        :notes,
        :received_date,
        :fiscal_year,
        :amount,
        tax_document_files_attributes: FilesController.multi_param_names
      )
    end
end
