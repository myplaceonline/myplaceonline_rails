class ProjectsController < MyplaceonlineController
  def show_created_updated
    false
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(projects.project_name) ASC"]
    end

    def obj_params
      params.require(:project).permit(
        :project_name,
        :notes,
        :start_date,
        :end_date,
        project_issues_attributes: [
          :id,
          :_destroy,
          :issue_name,
          :notes,
          :position
        ]
      )
    end
end
