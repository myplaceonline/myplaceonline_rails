class MusicalGroupsController < MyplaceonlineController
  protected
    def sorts
      ["lower(musical_groups.musical_group_name) ASC"]
    end

    def obj_params
      params.require(:musical_group).permit(MusicalGroup.params)
    end
end
