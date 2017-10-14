class QuestsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.quests.quest_title"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(quests.quest_title)"]
    end

    def obj_params
      params.require(:quest).permit(
        :quest_title,
        :notes,
        quest_files_attributes: FilesController.multi_param_names
      )
    end
end
