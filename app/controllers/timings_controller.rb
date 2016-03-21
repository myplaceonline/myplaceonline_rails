class TimingsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(timings.timing_name) ASC"]
    end

    def obj_params
      params.require(:timing).permit(
        :timing_name,
        :notes
      )
    end
end
