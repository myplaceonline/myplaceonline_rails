class SharesController < MyplaceonlineController
  protected
    def has_category
      false
    end
    
    def additional_sorts
      [
        [I18n.t("myplaceonline.shares.token"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(shares.token)"]
    end

    def obj_params
      params.require(:share).permit(
        :token,
        :use_count,
        :max_use_count
      )
    end
end
