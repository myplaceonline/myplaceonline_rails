class HobbiesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.hobbies.hobby_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(hobbies.hobby_name)"]
    end

    def obj_params
      params.require(:hobby).permit(
        :hobby_name,
        :notes
      )
    end
end
