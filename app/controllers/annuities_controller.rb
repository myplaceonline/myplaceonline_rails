class AnnuitiesController < MyplaceonlineController
  protected
    def default_sort_columns
      ["lower(#{model.table_name}.annuity_name)"]
    end
    
    def additional_sorts
      [
        [I18n.t("myplaceonline.annuities.annuity_name"), default_sort_columns[0]]
      ]
    end

    def obj_params
      params.require(:annuity).permit(
        :annuity_name,
        :notes
      )
    end
end
