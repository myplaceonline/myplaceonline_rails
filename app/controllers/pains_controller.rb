class PainsController < MyplaceonlineController
  def model
    Pain
  end

  def display_obj(obj)
    obj.display
  end

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
    
    def new_obj_initialize
      @obj.pain_start_time = DateTime.now
    end
end
