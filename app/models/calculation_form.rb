class CalculationForm < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :name, presence: true
  validates :equation, presence: true
  
  child_properties(name: :calculation_inputs)
  
  #validates_associated :root_element
  #validates_presence_of :root_element
  child_property(name: :root_element, model: CalculationElement)
  
  def display
    name
  end
  
  after_initialize :init

  def init
    self.is_duplicate = false if self.is_duplicate.nil?
  end
  
  validate do
    if !equation.blank?
      calc = Dentaku::Calculator.new
      dependencies = calc.dependencies(equation)
      dependencies.each do |dependency|
        found_input = calculation_inputs.find{|calculation_input| calculation_input.variable_name == dependency.to_s}
        if found_input.nil?
          errors.add(:equation, I18n.t("myplaceonline.calculation_forms.inputs_missing", variable_name: dependency.to_s))
        end
      end
      
      calculation_inputs.each do |calculation_input|
        calc.store(calculation_input.variable_name => 1)
      end
      
      calc.evaluate(equation).to_s
    end
  end
end
