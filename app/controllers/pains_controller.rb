class PainsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["pains.pain_start_time DESC"]
    end

    def obj_params
      params.require(:pain).permit(:pain_start_time, :pain_end_time, :pain_location, :intensity, :notes)
    end
end
