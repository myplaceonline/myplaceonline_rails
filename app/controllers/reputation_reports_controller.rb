class ReputationReportsController < MyplaceonlineController
  def may_upload
    true
  end

  def use_bubble?
    true
  end
  
  def bubble_text(obj)
    obj.report_status_s
  end

  protected
    def obj_params
      params.require(:reputation_report).permit(
        :short_description,
        :story,
        :notes,
        reputation_report_files_attributes: FilesController.multi_param_names,
      )
    end
end
