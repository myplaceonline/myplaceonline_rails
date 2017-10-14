class MusicalGroupsController < MyplaceonlineController
  protected
    def additional_sorts
      [
        [I18n.t("myplaceonline.musical_groups.musical_group_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(musical_groups.musical_group_name)"]
    end

    def obj_params
      params.require(:musical_group).permit(MusicalGroup.params)
    end

    def insecure
      true
    end
end
