class QuestsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(quests.quest_title) ASC"]
    end

    def obj_params
      params.require(:quest).permit(
        :quest_title,
        :notes
      )
    end
end
