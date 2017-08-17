class TranslationsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(translations.translation_input) ASC"]
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
