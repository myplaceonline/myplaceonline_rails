class CalculationForm < ActiveRecord::Base
  belongs_to :identity
  
  validates :name, presence: true
  validates :equation, presence: true
  
  has_many :calculation_inputs, :dependent => :destroy
  accepts_nested_attributes_for :calculation_inputs, allow_destroy: true, reject_if: :all_blank
  
  belongs_to :root_element, class_name: CalculationElement, autosave: true
  #validates_associated :root_element
  #validates_presence_of :root_element
  accepts_nested_attributes_for :root_element
  
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
    end
  end
end
