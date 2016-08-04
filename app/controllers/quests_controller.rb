class QuestsController < MyplaceonlineController
  def may_upload
    true
  end

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
        :notes,
        quest_files_attributes: FilesController.multi_param_names
      )
    end
end
