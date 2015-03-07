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
      permit_tree = [
        :name,
        {
          calculation_inputs_attributes: [:id, :input_name, :_destroy]
        },
        tree_item("root_element_attributes", params["calculation_form"]["root_element_attributes"])
      ]
      params.require(:calculation_form).permit(permit_tree)
    end
    
    def tree_item(name, check)
      if !check.nil?
        {
          name.to_sym => [
            :id,
            :operator,
            left_operand_attributes: [
              :id,
              :constant_value,
              tree_item("calculation_element_attributes", !check["left_operand_attributes"].nil? ? check["left_operand_attributes"]["calculation_element_attributes"] : nil)
            ],
            right_operand_attributes: [
              :id,
              :constant_value,
              { calculation_input_attributes: [:id, :_destroy] },
              tree_item("calculation_element_attributes", !check["right_operand_attributes"].nil? ? check["right_operand_attributes"]["calculation_element_attributes"] : nil)
            ]
          ]
        }
      else
        {}
      end
    end

    def new_build
      @obj.root_element = CalculationElement.build
    end

    def update_presave
      check_nested_attributes(@obj, :calculation_inputs, :calculation_form)
    end
end
