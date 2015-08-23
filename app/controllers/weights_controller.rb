class WeightsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["weights.measure_date DESC"]
    end

    def obj_params
      params.require(:weight).permit(:amount, :amount_type, :measure_date, :source)
    end
end
