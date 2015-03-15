class CalculationInput < ActiveRecord::Base
  belongs_to :calculation_form
  
  # input_name:string
  # input_value:string
end
