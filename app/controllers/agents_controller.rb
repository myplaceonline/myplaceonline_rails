class AgentsController < MyplaceonlineController
  def may_upload
    true
  end

  def before_show_view
    true
  end

  def use_custom_heading
    true
  end
  
  def custom_heading
    @obj.display
  end

  def search_index_name
    Identity.table_name
  end
  
  def search_parent_category
    Agent.name
  end
  
  def show_add
    false
  end
  
  def show_back_to_list
    false
  end
  
  protected
    def insecure
      true
    end

    def obj_params
      params.require(:agent).permit(Agent.param_names)
    end
    
    def before_show
      @reputation_reports = @obj.public_reputation_reports
      @praises = @reputation_reports.count{|x| x.report_type == ReputationReport::REPORT_TYPE_PRAISE}
      @shames = @reputation_reports.count{|x| x.report_type == ReputationReport::REPORT_TYPE_SHAME}
    end
end
