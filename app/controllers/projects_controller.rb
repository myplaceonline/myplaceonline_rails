class ProjectsController < MyplaceonlineController
  def show_created_updated
    false
  end
  
  def delete_by_index
    set_obj
    
    result = {
      result: false
    }
    index = params[:index]
    if !index.blank?
      @obj.project_issues[index.to_i].destroy!
      result[:result] = true
    end
    render json: result
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
