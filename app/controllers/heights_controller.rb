class HeightsController < MyplaceonlineController
  def model
    Height
  end

  protected
    def insecure
      true
    end

    def sorts
      ["heights.measurement_date DESC"]
    end

    def obj_params
      params.require(:height).permit(:height_amount, :amount_type, :measurement_date, :measurement_source)
    end
    
    def new_obj_initialize
      @obj.amount_type = 0
      @obj.measurement_date = Date.today
    end
end
