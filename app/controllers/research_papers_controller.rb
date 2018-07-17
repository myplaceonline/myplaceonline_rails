class ResearchPapersController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def obj_params
      params.require(:research_paper).permit(
        document_attributes: DocumentsController.param_names
      )
    end
end
