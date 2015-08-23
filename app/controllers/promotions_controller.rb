class PromotionsController < MyplaceonlineController
  protected
    def sorts
      ["promotions.expires ASC", "lower(promotions.promotion_name) ASC"]
    end

    def obj_params
      params.require(:promotion).permit(
        :promotion_name,
        :started,
        :expires,
        :promotion_amount,
        :notes
      )
    end
end
