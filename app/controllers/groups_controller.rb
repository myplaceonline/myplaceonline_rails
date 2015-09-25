class GroupsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(groups.group_name) ASC"]
    end

    def obj_params
      params.require(:group).permit(
        :group_name,
        :notes
      )
    end
end
