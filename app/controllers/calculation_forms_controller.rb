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
      params.require(:calculation_form).permit(
        :name,
        root_element_attributes: [
          :operator,
          left_operand_attributes: [:constant_value],
          right_operand_attributes: [:constant_value]
        ]
      )
    end

    def new_build
      @obj.root_element = CalculationElement.build
    end
end
