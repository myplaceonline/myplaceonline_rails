class RepeatsController < MyplaceonlineController
  protected
    def obj_params
      params.require(:repeat).permit(
        :start_date,
        :period_type,
        :period
      )
    end

    def has_category
      false
    end
end
