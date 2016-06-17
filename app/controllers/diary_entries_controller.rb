class DiaryEntriesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["diary_entries.diary_time DESC"]
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

    def sensitive
      true
    end
end
