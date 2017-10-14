class TranslationsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.translations.translation_input"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(translations.translation_input)"]
    end

    def obj_params
      params.require(:translation).permit(
        :translation_input,
        :translation_output,
        :input_language,
        :output_language,
        :source,
        :website,
        :notes,
      )
    end
end
