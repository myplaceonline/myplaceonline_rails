class RepeatsController < MyplaceonlineController
  protected
    def sorts
      ["repeats.updated_at DESC"]
    end

    def obj_params
      params.require(:repeat).permit(
        :start_date,
        :period_type,
        :period
      )
    end
end
