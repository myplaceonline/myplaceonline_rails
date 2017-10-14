class DiaryEntriesController < MyplaceonlineController
  protected
    def default_sort_direction
      "desc"
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.diary_entries.diary_time"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["diary_entries.diary_time"]
    end

    def sensitive
      true
    end

    def obj_params
      params.require(:diary_entry).permit(
        :diary_time,
        :entry,
        :diary_title,
        :encrypt
      )
    end
end
