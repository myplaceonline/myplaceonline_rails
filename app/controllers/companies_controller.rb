class CompaniesController < MyplaceonlineController
  def may_upload
    true
  end
  
  def search_filters_model
    Company.name
  end
  
  def search_index_name
    Identity.table_name
  end
  
  protected
    def sorts
      ["lower(identities.name) ASC"]
    end

    def obj_params
      params.require(:company).permit(
        Company.param_names
      )
    end

    # Join because we're sorting by identity name
    def all_joins
      :company_identity
    end
    
    def all_includes
      :company_identity
    end
end
