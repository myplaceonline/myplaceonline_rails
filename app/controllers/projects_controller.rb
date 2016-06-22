class ProjectsController < MyplaceonlineController
  protected
    def sorts
      ["lower(projects.project_name) ASC"]
    end

    def obj_params
      params.require(:project).permit(
        :project_name,
        :notes,
        :start_date,
        :end_date
      )
    end
end
