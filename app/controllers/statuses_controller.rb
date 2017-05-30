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
        :three_good_things,
        :feeling,
        :status1,
        :status2,
        :status3,
        :stoic_ailments,
        :stoic_failings,
        :stoic_failed,
        :stoic_duties,
        :stoic_improvement,
        :stoic_faults,
      )
    end
end
