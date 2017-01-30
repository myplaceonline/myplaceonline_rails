class PatentsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["patents.publication_date DESC NULLS LAST", "lower(patents.patent_name) ASC"]
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
        test_object_files_attributes: FilesController.multi_param_names
      )
    end
end
