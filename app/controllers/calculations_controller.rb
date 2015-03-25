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
      params.require(:calculation).permit(
        :name,
        :original_calculation_form_id,
        {
          calculation_form_attributes: CalculationFormsController.param_names
        }
      )
    end

    def create_presave
      if !@obj.original_calculation_form_id.nil? && @obj.calculation_form.nil?
        existing_form = CalculationForm.find(@obj.original_calculation_form_id)
        new_inputs = existing_form.calculation_inputs.map{|calculation_input| calculation_input.dup}
        @obj.calculation_form = existing_form.dup
        @obj.calculation_form.calculation_inputs = new_inputs
        @obj.calculation_form.is_duplicate = true
      end
    end
end
