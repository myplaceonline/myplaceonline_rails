class ToDosController < MyplaceonlineController
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.to_dos.short_description"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(to_dos.short_description)"]
    end

    def obj_params
      params.require(:to_do).permit(
        :short_description,
        :due_time,
        :notes
      )
    end

    def insecure
      true
    end
end
