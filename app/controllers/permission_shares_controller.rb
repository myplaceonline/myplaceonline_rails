class PermissionSharesController < MyplaceonlineController
  protected
    def has_category
      false
    end
    
    def sorts
      ["permission_shares.updated_at DESC"]
    end

    def obj_params
      params.require(:permission_share).permit(
        :trash
      )
    end
end
