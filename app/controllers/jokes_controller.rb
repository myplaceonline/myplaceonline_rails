class JokesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.jokes.name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(jokes.name)"]
    end

    def obj_params
      params.require(:joke).permit(:name, :joke, :source)
    end
end
