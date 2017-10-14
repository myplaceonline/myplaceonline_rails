class PoemsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.poems.poem_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(poems.poem_name)"]
    end

    def obj_params
      params.require(:poem).permit(
        :poem_name,
        :poem,
        :poem_author,
        :poem_link
      )
    end
end
