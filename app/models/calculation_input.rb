class CalculationInput < ActiveRecord::Base
  belongs_to :calculation_form
  
  # input_name:string
  # input_value:string
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
