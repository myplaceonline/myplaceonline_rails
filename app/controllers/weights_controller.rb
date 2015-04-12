class WeightsController < MyplaceonlineController
  def model
    Weight
  end

  def display_obj(obj)
    obj.display
  end

  protected
    def sorts
      ["weights.measure_date DESC"]
    end

    def obj_params
      params.require(:weight).permit(:amount, :amount_type, :measure_date, :source)
    end
    
    def new_obj_initialize
      @obj.amount_type = 0
    end
end
