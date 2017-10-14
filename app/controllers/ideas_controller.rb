class IdeasController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.ideas.name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(ideas.name)"]
    end

    def obj_params
      params.require(:idea).permit(:name, :idea)
    end
end
