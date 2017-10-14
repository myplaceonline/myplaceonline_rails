class AccomplishmentsController < MyplaceonlineController
  protected
    def default_sort_columns
      ["lower(#{model.table_name}.name)"]
    end
    
    def additional_sorts
      [
        [I18n.t("myplaceonline.accomplishments.name"), default_sort_columns[0]]
      ]
    end

    def obj_params
      params.require(:accomplishment).permit(:name, :accomplishment)
    end
end
