class PatentsController < MyplaceonlineController
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

    def additional_sorts
      [
        [I18n.t("myplaceonline.patents.publication_date"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["patents.publication_date", "lower(patents.patent_name) ASC"]
    end

    def obj_params
      params.require(:patent).permit(
        :patent_name,
        :patent_number,
        :authors,
        :region,
        :filed_date,
        :publication_date,
        :patent_abstract,
        :patent_text,
        :notes,
        patent_files_attributes: FilesController.multi_param_names
      )
    end
end
