class BoycottsController < MyplaceonlineController
  protected
    def insecure
      true
    end

    def sorts
      ["lower(boycotts.boycott_name) ASC"]
    end

    def obj_params
      params.require(:boycott).permit(
        :boycott_name,
        :boycott_start,
        :notes,
      )
    end
end
