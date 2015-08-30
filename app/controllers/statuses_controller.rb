class StatusesController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["statuses.status_time DESC"]
    end

    def obj_params
      params.require(:status).permit(
        :status_time,
        :three_good_things
      )
    end
end
