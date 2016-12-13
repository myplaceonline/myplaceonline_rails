class ProjectsController < MyplaceonlineController
  def show_created_updated
    false
  end
  
  def delete_by_index
    set_obj
    
    result = {
      result: false
    }
    issue_id = params[:issue_id]
    if !issue_id.blank?
      @obj.project_issues[@obj.project_issues.to_a.index{|i| i.id == issue_id.to_i}].complete_successfully
      result[:result] = true
    end
    render json: result
  end

  def data_split_icon
    "plus"
  end
  
  def split_link(obj)
    ActionController::Base.helpers.link_to(
      I18n.t("myplaceonline.projects.project_issue_add"),
      project_project_issues_new_path(obj)
    )
  end

  def may_upload
    true
  end

  def footer_items_show
    [
      {
        title: I18n.t("myplaceonline.projects.project_issue_add"),
        link: new_project_project_issue_path(@obj),
        icon: "plus"
      },
      {
        title: I18n.t("myplaceonline.projects.project_issues"),
        link: project_project_issues_path(@obj),
        icon: "bars"
      }
    ] + super
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
        :default_to_top,
        project_issues_attributes: [
          :id,
          :_destroy,
          :issue_name,
          :notes,
          :position,
          project_issue_files_attributes: FilesController.multi_param_names
        ]
      )
    end
end
