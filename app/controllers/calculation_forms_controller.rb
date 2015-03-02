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
              tree_item("calculation_element_attributes", !check["calculation_element_attributes"].nil? ? check["calculation_element_attributes"]["left_operand_attributes"] : nil)
            ],
            right_operand_attributes: [
              :id,
              :constant_value,
              tree_item("calculation_element_attributes", !check["calculation_element_attributes"].nil? ? check["calculation_element_attributes"]["right_operand_attributes"] : nil)
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
end
