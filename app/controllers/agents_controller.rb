class AgentsController < MyplaceonlineController
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def obj_params
      params.require(:agent).permit(Agent.param_names)
    end
end
