class QuotesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.quotes.quote_text"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(quotes.quote_text)"]
    end

    def obj_params
      params.require(:quote).permit(Quote.params)
    end
end
