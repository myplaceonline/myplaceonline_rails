class CalculationFormsController < MyplaceonlineController
  def model
    CalculationForm
  end

  def display_obj(obj)
    obj.name
  end

  protected
    def sorts
      ["lower(calculation_forms.name) ASC"]
    end

    def obj_params
      params.require(:calculation_form).permit(:name)
    end
end
