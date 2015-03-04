class CalculationsController < MyplaceonlineController
  def model
    Calculation
  end

  def display_obj(obj)
    obj.name
  end

  protected
    def sorts
      ["lower(calculations.name) ASC"]
    end

    def obj_params
      params.require(:calculation).permit(:name)
    end
end
