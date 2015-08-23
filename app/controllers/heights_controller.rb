class HeightsController < MyplaceonlineController
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
end
