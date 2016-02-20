class SharesController < MyplaceonlineController
  protected
    def has_category
      false
    end
    
    def sorts
      ["lower(shares.token) ASC"]
    end

    def obj_params
      params.require(:share).permit(
        :token
      )
    end
end
