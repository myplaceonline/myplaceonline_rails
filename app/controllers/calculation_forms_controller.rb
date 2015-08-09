class CalculationFormsController < MyplaceonlineController
  def model
    CalculationForm
  end
  
  def self.param_names
    [
      :id,
      :name,
      :equation,
      :is_duplicate,
      {
        calculation_inputs_attributes: [:id, :input_name, :input_value, :variable_name, :_destroy]
      }
    ]
  end

  protected
    def all
      model.where(
        owner_id: current_user.primary_identity.id,
        is_duplicate: false
      )
    end
    
    def sorts
      ["lower(calculation_forms.name) ASC"]
    end

    def obj_params
      permit_tree = CalculationFormsController.param_names
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
end
