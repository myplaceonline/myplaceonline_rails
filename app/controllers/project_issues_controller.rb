class ProjectIssuesController < MyplaceonlineController
  def path_name
    "project_project_issue"
  end

  def form_path
    "project_issues/form"
  end

  protected
    def insecure
      true
    end

    def sorts
      ["project_issues.position ASC"]
    end

    def obj_params
      params.require(:project_issue).permit(
        :issue_name, :notes
      )
    end
    
    def has_category
      false
    end
    
    def nested
      true
    end
    
    def additional_items?
      false
    end

    def parent_model
      Project
    end
end
