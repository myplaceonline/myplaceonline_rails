class Calculation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  
  before_validation :check_calculation_before_create
  
  validates :name, presence: true
  
  child_property(name: :calculation_form, required: true)

  belongs_to :original_calculation_form, class_name: "CalculationForm"
  
  def display
    name
  end

  validate do
    if !calculation_form.nil?
      calc = create_cal
      dependencies = calc.dependencies(calculation_form.equation)
      dependencies.each do |dependency|
        missing_input = calculation_form.calculation_inputs.find{|calculation_input| calculation_input.variable_name == dependency.to_s }
        if !missing_input.nil?
          errors.add(:answer, I18n.t("myplaceonline.calculations.input_missing", input_name: missing_input.input_name))
        end
      end
    end
  end
  
  def create_cal
    calc = Dentaku::Calculator.new
    calculation_form.calculation_inputs.each do |calculation_input|
      if !calculation_input.input_value.blank?
        calc.store(calculation_input.variable_name => calculation_input.input_value.to_f)
      end
    end
    calc
  end
  
  def evaluate
    if !calculation_form.nil?
      begin
        create_cal.evaluate(calculation_form.equation).to_s
      rescue Dentaku::ParseError => e
        "Error: #{e}"
      end
    else
      nil
    end
  end
  
  def check_calculation_before_create
    if !self.original_calculation_form_id.nil? && self.calculation_form.nil?
      existing_form = User.current_user.current_identity.calculation_forms_available.find(self.original_calculation_form_id)
      new_inputs = existing_form.calculation_inputs.map{|calculation_input| calculation_input.dup}
      self.calculation_form = existing_form.dup
      self.calculation_form.calculation_inputs = new_inputs
      self.calculation_form.is_duplicate = true
    end
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    if !params.nil? && !params[:form].nil?
      existing_form = User.current_user.current_identity.calculation_forms_available.find(params[:form].to_i)
      if !existing_form.nil?
        result.original_calculation_form_id = existing_form.id
        result.check_calculation_before_create
      end
    end
    result
  end
end
