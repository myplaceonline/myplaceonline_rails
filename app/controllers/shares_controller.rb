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
        :token,
        :use_count,
        :max_use_count
      )
    end
end
